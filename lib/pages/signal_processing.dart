import 'package:csv/csv.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'package:myapp/pages/bluetooth/BackgroundCollectingTask2.dart';
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
  double frequency = 0;
}

class RecordObject {
  final Duration peak;
  final Duration duration;
  final double intensity;

  RecordObject({
    required this.peak,
    required this.duration,
    required this.intensity,
  });
}

List<double> totalDataEmg1 = [];
List<double> totalDataEmg2 = [];
int lastSampleIndex = 0; // Me quedo con la ultima muestra que procese
Duration lastSampleDuration = Duration(seconds: 0);
List<dynamic> totalPeaks = [];
List<dynamic> totalPeaksWidths = [];
List<dynamic> totalPeaksIntensity = [];

List<RecordObject> contractionsDetails = [];

Future<ReportParam> SignalProcessing(List<double> measuredData, Duration duration) async {
  print('procesandoooooUUUUU');
  List<List<dynamic>> data = [];
  // data = await loadCSV();
  // List<double> emg2 = data.map((row) => row[2]).cast<double>().toList();

  // int samples = emg2.length;
  // double dur = 32.41; // Duration of the recording in minutes
  // double frequency = samples / (dur * 60);

  // int window = (180 * frequency).toInt();
  // int overlapping = (60 * frequency).toInt();
  // List<double> windowData;
  // List<dynamic> windowOutput;
  // List<dynamic> picosTotales = [];
  // List<int> filteredList = [];
  //
  // for (int i = 0; i < emg2.length; i += window - overlapping) {
  //   if (i == 0) {
  //     windowData = emg2.sublist(i, window - overlapping);
  //     windowOutput =
  //         await procesarEMG(data, windowData, Duration(seconds: 120));
  //     for (int pico in windowOutput[0]) {
  //         picosTotales.add(pico + i);
  //     }
  //     // picosTotales.addAll(windowOutput[0]);
  //     print('Ventana: $i hasta ${window - overlapping}');
  //     print('Pico parcial ${windowOutput[0]}');
  //     print('Length EMG 2: ${emg2.length}');
  //     i -= overlapping;
  //   } else {
  //     if (i + window >= emg2.length) {
  //       print('VENTANA FINAL');
  //       // print('i FINAL: $i');
  //       // windowData = emg2.sublist(i);
  //       // print('HOLAAA ${((emg2.length - i)/frequency).toInt()}');
  //       // windowOutput = await procesarEMG(data, windowData, Duration(seconds:((emg2.length - i)/frequency).toInt()));
  //       // print('HOLAAA2222');
  //     } else {
  //       windowData = emg2.sublist(i, i + window);
  //       windowOutput =
  //           await procesarEMG(data, windowData, Duration(seconds: 180));
  //       for (int pico in windowOutput[0]) {
  //           picosTotales.add(pico + i);
  //       }
  //       // picosTotales.addAll(windowOutput[0]);
  //       print('Ventana: $i hasta ${i + window}');
  //       print('Pico parcial ${windowOutput[0]}');
  //     }
  //     print('Picos totales: $picosTotales');
  //     picosTotales = picosTotales.toSet().toList();
  //
  //     for (int i = 0; i < picosTotales.length; i++) {
  //       if (filteredList.isEmpty || picosTotales[i] - 1000 > filteredList.last) {
  //         // Agregar el elemento actual si la lista filtrada está vacía o si el elemento actual está más lejos de 200 (5s) unidades del último elemento en la lista filtrada
  //         filteredList.add(picosTotales[i]);
  //       }
  //     }
  //     print('Picos totales filtrados: ${filteredList}');
  //   }
  // }
  //
  // // print('Picos Totales $picosTotales');
  // print('Picos Totales ${filteredList.length}');
  List<dynamic> output;

  int samples = measuredData.length;
  double frequency = (samples / (duration.inSeconds))/2;
  int overlapping = (60*frequency).toInt();

  List<double> windowData = measuredData.sublist(lastSampleIndex == 0 ? lastSampleIndex : lastSampleIndex - overlapping);
  totalDataSplit(windowData);

  List<double> windowDataEmg1 = totalDataEmg1.sublist(lastSampleIndex == 0 ? lastSampleIndex : lastSampleIndex - overlapping);
  output = await procesarEMG(data, windowDataEmg1, duration-lastSampleDuration);


  for (int i = 0; i < output[0].length; i++) {
    if (totalPeaks.isEmpty || output[0][i] - 1000 > totalPeaks.last) { // picos iguales +- 1000 muestras
      // Agregar el elemento actual si la lista filtrada está vacía o si el elemento actual está más lejos de 200 (5s) unidades del último elemento en la lista filtrada
      int currentPeakIndex = output[0][i] + (lastSampleIndex == 0 ? lastSampleIndex : lastSampleIndex - overlapping);
      totalPeaks.add(currentPeakIndex);
      totalPeaksWidths.add(output[1].widths[i]);
      totalPeaksIntensity.add(totalDataEmg1[currentPeakIndex]);

      contractionsDetails.add(
        RecordObject(
          peak: Duration(seconds: (currentPeakIndex/frequency).toInt()),
          duration: Duration(seconds: output[1].widths[i]),
          intensity: double.parse(totalDataEmg1[currentPeakIndex].toStringAsFixed(2)),
      ));

    }
  }

  // Me quedo con la ultima muestra que procese
  lastSampleIndex = (totalDataEmg1.length - 1);
  lastSampleDuration = duration;

  //---------widths--------
  // int timeBet = 0;
  int avgDuration = 0;

  if (totalPeaksWidths.length > 0) {
    avgDuration = (((totalPeaksWidths).reduce((a, b) =>
    a + b) / // calcula la duracion promedio de las contracciones
        totalPeaksWidths.length))
        .round();

    // timeBet = ((output[1].timeBetweens).reduce((a, b) => a + b) /
    //     output[1].timeBetweens.length)
    //     .round();
  }

  //-----intensidad-------
  double avgIntensity = 0;

  if (totalPeaksIntensity.length > 0) {
    avgIntensity = (((totalPeaksIntensity).reduce((a, b) =>
    a + b) / // calcula la duracion promedio de las contracciones
        totalPeaksIntensity.length));
        // .round();
    avgIntensity = (avgIntensity / (201 * 33.8)) * 1000; //intensidad a mV
  }

  // //------- # contracciones en los ultimos 10'--------

  List<dynamic> outputLast10 = [];
  int startIndexLast10 = ((duration.inSeconds - (10 * 60)) * frequency).toInt();

  // // Calcular el tiempo de inicio de los últimos 10 minutos
  // if (duration.inSeconds >= 10*60) {
  //   List<double> windowDataEmg1Last10 = totalDataEmg1.sublist(startIndex);
  //   outputLast10 =
  //   await procesarEMG(data, windowDataEmg1Last10, Duration( seconds: 10*60));
  // }
  // else {
  //   outputLast10 = totalPeaks;
  // }

  outputLast10 = totalPeaks.where((pico) => pico > startIndexLast10).toList();

  // // Filtrar los picos que ocurrieron en los últimos 10 minutos de la señal
  // List<int> filteredPeaks = [];
  // for (int i = 0; i < peaks.length; i++) {
  //   if (peaks[i] * (1 / frequency2) >= startTimeSeconds) {
  //     filteredPeaks.add(peaks[i]);
  //   }
  // }
  // // Contar el número de picos filtrados
  // int last10 = filteredPeaks.length;

  ReportParam actualReport = ReportParam();

  actualReport.number = totalPeaks.length;
  actualReport.duration = avgDuration;
  // actualReport.timeBetween = output[2];
  actualReport.intensity = avgIntensity;
  // actualReport.frequency = output[4];
  actualReport.last10 = outputLast10.length;

  return actualReport;
}

Future<List<List<dynamic>>> loadCSV() async {
  List<List<dynamic>> csvData = [];
  String data = await rootBundle.loadString("assets/signals/valentina.csv");
  List<List<dynamic>> rowsAsListOfValues = CsvToListConverter().convert(data);
  csvData = rowsAsListOfValues;
  return csvData;
}

Future<List<dynamic>> procesarEMG(
    csvData, List<double> data, Duration duration) async {
  // --------Señales de EMG crudas--------
  // List<double> emg1 = csvData.map((row) => row[1] as double).toList();
  // List<double> emg2 = csvData.map((row) => row[2]).cast<double>().toList();

  //----------- Calculo la frecuencia----------
  //Fake freq
  // int samples = emg2.length;
  // double dur = 32.41; // Duration of the recording in minutes
  // double frequency2 = samples / (dur * 60);

  //frequency
  int totalSamples = data.length;
  double frequency = totalSamples / duration.inSeconds;

  //------------ Aplicar filtro pasa banda-------------
  // List<double> filteredEmg = filterEmg(emg2);
  List<double> filteredEmg = filterEmg(data);

  // ------------Calcular envolvente-------------
  List<List<double>> envelopeCalc = calculateEnvelope(filteredEmg);
  // List<double> absSignal = envelopeCalc[0];
  List<double> envelope = envelopeCalc[1];

  // ----------Detectar picos y duracion------------
  List<int> peaks =
      findPeaks(envelope, 0.05, (40 * frequency).round(), frequency);

  if (peaks.length > 0 && peaks[peaks.length -1] == data.length-1){
    peaks.removeLast();
  }

  PeakIntervalResult peaksIntervals = peakWidths(envelope, peaks, 0.77, envelope.length, frequency);

  List<int> indicesAEliminar = [];

  for (int i = 0; i < peaksIntervals.widths.length; i++) {
    if (35 > peaksIntervals.widths[i] || peaksIntervals.widths[i] > 180) {
      indicesAEliminar.add(i);
    }
  }

  for (int i = indicesAEliminar.length - 1; i >= 0; i--) {
    int indice = indicesAEliminar[i];
    peaks.removeAt(indice);
    peaksIntervals.widths.removeAt(indice);
    peaksIntervals.timeBetweens.removeAt(indice);
  }

  List<dynamic> output = [];

  output.add(peaks);
  output.add(peaksIntervals);

  return output;
}

List<double> filterEmg(List<double> emgSignal) {
  double sampleRate = 50.0; // Frecuencia de muestreo
  double centerFrequency = 0.6; // Frecuencia central del filtro pasa banda
  double widthFrequency = 0.8; // Ancho del filtro pasa banda

  Butterworth butterworth = Butterworth();
  butterworth.bandPass(2, sampleRate, centerFrequency, widthFrequency);

  List<double> filteredData = [];
  for (var v in emgSignal) {
    filteredData.add(butterworth.filter(v));
  }

  return filteredData;
}

List<List<double>> calculateEnvelope(List<double> signal,
    {double cutoffFreq = 0.0166}) {
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
  List<double> envelope =
      absSignal.map((value) => butterworth.filter(value)).toList();

  return [absSignal, envelope];
}

class Peak {
  int index;
  int width;

  Peak(this.index, this.width);
}

List<int> findPeaks(
    List<double> data, double minHeight, int minDistance, double frequency) {
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

PeakIntervalResult peakWidths(List<double> signal, List<int> peaks, double relHeight, int wlen, double frequency) {
  List<int> widths = [];
  List<int> timeBetweens = [];
  //List<double> prominences = [];

  int prevRightIndex = 0;

  for (int peakIndex in peaks) {
    double peakValue = signal[peakIndex];

    // Calcular la altura de evaluación
    double peakProminence = calculatePeakProminence(signal, peakIndex, wlen);

    // Calcular la anchura
    List<int> intervalParam = calculatePeakWidth(
        signal, peakIndex, peakValue, peakProminence, relHeight);

    int width = intervalParam[0];
    int currentLeftIndex = intervalParam[1];
    int currentRightIndex = intervalParam[2];

    int timeBetween = currentLeftIndex - prevRightIndex;

    prevRightIndex = currentRightIndex;

    // Almacenar los resultados
    widths.add((width/frequency).toInt());
    timeBetweens.add(timeBetween);
    //prominences.add(peakProminence);
  }

  return PeakIntervalResult(widths, timeBetweens);
}

double calculatePeakProminence(List<double> signal, int peakIndex, int wlen) {
  double peakValue = signal[peakIndex];

  // Extender una línea horizontal desde el pico hacia la izquierda y la derecha
  int leftIndex = peakIndex;
  while (leftIndex > 0 &&
      peakIndex - leftIndex < wlen &&
      signal[leftIndex - 1] < peakValue) {
    leftIndex--;
  }

  int rightIndex = peakIndex;
  while (rightIndex < signal.length - 1 &&
      rightIndex - peakIndex < wlen &&
      signal[rightIndex + 1] < peakValue) {
    rightIndex++;
  }

  // Encontrar los valores mínimos en cada lado
  double leftMin = signal.sublist(leftIndex, peakIndex).reduce(min);
  double rightMin = signal.sublist(peakIndex, rightIndex + 1).reduce(min);

  // Calcular la prominencia
  double prominence = max(peakValue - leftMin, peakValue - rightMin);

  return prominence;
}

List<int> calculatePeakWidth(List<double> signal, int peakIndex,
    double peakValue, double peakProminence, double relHeight) {
  double evaluationHeight = peakValue - relHeight * peakProminence;

  // Encontrar el índice del punto más bajo a la izquierda
  int leftIndex = peakIndex;
  while (leftIndex > 0 && signal[leftIndex - 1] >= evaluationHeight) {
    leftIndex--;
  }

  // Encontrar el índice del punto más bajo a la derecha
  int rightIndex = peakIndex;
  while (rightIndex < signal.length - 1 &&
      signal[rightIndex + 1] >= evaluationHeight) {
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

void totalDataSplit (data) {
  for (int i = 0; i < data.length -1; i += 2) {
    totalDataEmg1.add(data[i]);
    totalDataEmg2.add(data[i+1]);
  }
}