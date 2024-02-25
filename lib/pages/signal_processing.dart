import 'package:csv/csv.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:iirjdart/butterworth.dart';
import 'dart:math';

class ReportParam {
  int number = 0;
  int duration = 0;
  int timeBetween = 0;
  int last10 = 0;
  double intensity = 0;
}

Future<ReportParam> SignalProcessing() async {

  List<List<dynamic>> data = [];
  List<dynamic> output;
  ReportParam actualReport = ReportParam();

  data = await loadCSV();

  output= await procesarEMG(data);

  actualReport.number = output[0];
  actualReport.duration = output[1];
  actualReport.timeBetween = output[2];
  actualReport.intensity = output[3];

  return actualReport;
}


Future<List<List<dynamic>>> loadCSV() async {
  List<List<dynamic>> csvData = [];
  String data = await rootBundle.loadString("assets/signals/valentina.csv");
  List<List<dynamic>> rowsAsListOfValues = CsvToListConverter().convert(data);
  csvData = rowsAsListOfValues;
  return csvData;
}


Future<List<dynamic>> procesarEMG(csvData) async {
    // --------Señales de EMG crudas--------
    // List<double> emg1 = csvData.map((row) => row[1] as double).toList();
    List<double> emg2 = csvData.map((row) => row[2]).cast<double>().toList();

    //----------- Calculo la frecuencia----------
    int samples = emg2.length;
    double duration = 32.41; // Duration of the recording in minutes
    double frequency = samples / (duration * 60);

    //------------ Aplicar filtro pasa banda-------------
    List<double> filteredEmg = filterEmg(emg2);

    // ------------Calcular envolvente-------------
    List<List<double>> envelopeCalc = calculateEnvelope(filteredEmg);
    List<double> absSignal = envelopeCalc[0];
    List<double> envelope = envelopeCalc[1];

    // ----------Detectar picos y duracion------------
    List<int> peaks = findPeaks(envelope, 0.05, (40*frequency).round(), frequency);

    int numPeaks = peaks.length;

    PeakIntervalResult peaksIntervals = peakWidths(envelope, peaks, 0.77, 8000 );

    int contDuration = (((peaksIntervals.widths).reduce((a,b) => a+b)/peaksIntervals.widths.length)/frequency).round();

    int timeBet = ((peaksIntervals.timeBetweens).reduce((a,b) => a+b)/peaksIntervals.timeBetweens.length).round();

    double sum = 0;
    for (int i = 0; i < peaks.length ; i++){
      sum += emg2[peaks[i]];
    }

    double intensity = (sum / (201 * 33.8))*1000/peaks.length;
    print('intensity: $intensity');

    List<dynamic> output=[];

    output.add(numPeaks);
    output.add(contDuration);
    output.add(timeBet);
    output.add(intensity);

    return output;
}



List<double> filterEmg(List<double> emgSignal) {

  double sampleRate = 50.0; // Frecuencia de muestreo
  double centerFrequency = 0.6; // Frecuencia central del filtro pasa banda
  double widthFrequency = 0.8; // Ancho del filtro pasa banda

  Butterworth butterworth = Butterworth();
  butterworth.bandPass(2, sampleRate, centerFrequency, widthFrequency);

  List<double> filteredData = [];
  for(var v in emgSignal) {
    filteredData.add(butterworth.filter(v));
  }

  print("filtered data: $filteredData");

  return filteredData;
}

List<List<double>> calculateEnvelope(List<double> signal, {double cutoffFreq = 0.0166}) {
  // Calcular el valor absoluto
  List<double> absSignal = signal.map((value) => value.abs()).toList();

  // Filtro pasa bajo de 0.0166 Hz para obtener la envolvente
  double fs = 50.0; // Ajusta según tu frecuencia de muestreo
  //double nyquist = 0.5 * fs;
  //double normalCutoff = cutoffFreq / nyquist;
  double normalCutoff = cutoffFreq;

  // Diseñar un filtro pasa bajo Butterworth
  Butterworth butterworth = Butterworth();
  butterworth.lowPass(1, fs, normalCutoff);

  // Aplicar el filtro a la señal absoluta
  List<double> envelope = absSignal.map((value) => butterworth.filter(value)).toList();

  return [absSignal, envelope];
}


class Peak {
  int index;
  int width;

  Peak(this.index, this.width);
}

List<int> findPeaks(List<double> data, double minHeight, int minDistance, double frequency) {
  List<int> peakIndex = [];

  if (data.length < 3 || minDistance < 1) {
    // No hay suficientes datos o distancia mínima no válida
    return peakIndex;
  }

  bool isPeak(int index) {
    double value = data[index];
    if (value > minHeight) {
      for (int i = index - minDistance; i < index; i++) {
        if (i >= 0 && data[i] >= value) {
          return false;
        }
      }
      for (int i = index + 1; i <= index + minDistance; i++) {
        if (i < data.length && data[i] >= value) {
          return false;
        }
      }
      return true;
    }
    return false;
  }

  for (int i = 1; i < data.length - 1; i++) {
    if (isPeak(i)) {
      peakIndex.add(i);
    }
  }

  return peakIndex;
}

class PeakIntervalResult {
  final List<int> widths;
  final List<int> timeBetweens;

  PeakIntervalResult(this.widths, this.timeBetweens);
}

PeakIntervalResult peakWidths(List<double> signal, List<int> peaks, double relHeight, int wlen) {
  List<int> widths = [];
  List<int> timeBetweens = [];
  //List<double> prominences = [];

  int prevRightIndex = 0;

  for (int peakIndex in peaks) {
    double peakValue = signal[peakIndex];

    // Calcular la altura de evaluación
    double peakProminence = calculatePeakProminence(signal, peakIndex, wlen);

    // Calcular la anchura
    List<int> intervalParam = calculatePeakWidth(signal, peakIndex, peakValue, peakProminence, relHeight);

    int width = intervalParam[0];
    int currentLeftIndex = intervalParam[1];
    int currentRightIndex = intervalParam[2];

    int timeBetween = currentLeftIndex - prevRightIndex;

    prevRightIndex = currentRightIndex;

    // Almacenar los resultados
    widths.add(width);
    timeBetweens.add(timeBetween);
    //prominences.add(peakProminence);
  }

  return PeakIntervalResult(widths, timeBetweens);
}

double calculatePeakProminence(List<double> signal, int peakIndex, int wlen) {
  double peakValue = signal[peakIndex];

  // Extender una línea horizontal desde el pico hacia la izquierda y la derecha
  int leftIndex = peakIndex;
  while (leftIndex > 0 && peakIndex - leftIndex < wlen && signal[leftIndex - 1] < peakValue) {
    leftIndex--;
  }

  int rightIndex = peakIndex;
  while (rightIndex < signal.length - 1 && rightIndex - peakIndex < wlen && signal[rightIndex + 1] < peakValue) {
    rightIndex++;
  }

  // Encontrar los valores mínimos en cada lado
  double leftMin = signal.sublist(leftIndex, peakIndex).reduce(min);
  double rightMin = signal.sublist(peakIndex, rightIndex + 1).reduce(min);

  // Calcular la prominencia
  double prominence = max(peakValue - leftMin, peakValue - rightMin);

  return prominence;
}

List<int> calculatePeakWidth(List<double> signal, int peakIndex, double peakValue, double peakProminence, double relHeight) {
  double evaluationHeight = peakValue - relHeight * peakProminence;

  // Encontrar el índice del punto más bajo a la izquierda
  int leftIndex = peakIndex;
  while (leftIndex > 0 && signal[leftIndex - 1] >= evaluationHeight) {
    leftIndex--;
  }

  // Encontrar el índice del punto más bajo a la derecha
  int rightIndex = peakIndex;
  while (rightIndex < signal.length - 1 && signal[rightIndex + 1] >= evaluationHeight) {
    rightIndex++;
  }

  // Calcular el ancho
  int width = (rightIndex - leftIndex + 1.0).toInt();

  List<int> parameters = [width, leftIndex, rightIndex];


  return parameters;
}





Future<void> saveCSVFile(List<double> csvData) async {
  List<List<dynamic>> csvContent = [];

  for (int i = 0; i < csvData.length; i++) {
    final List<dynamic> row = [
      csvData[i],
    ];
    csvContent.add(row);
  }

  final Directory? directory = await getExternalStorageDirectory();
  final file = File('${directory?.path}/${DateTime.now()} - Graficos.csv');

  final csvFileContent = const ListToCsvConverter().convert(csvContent);
  await file.writeAsString(csvFileContent);

  print('CSV file for plots saved: ${file.path}');
}




