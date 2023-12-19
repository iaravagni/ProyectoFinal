import 'package:flutter/material.dart';
import 'package:csv/csv.dart';
import 'dart:async';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:scidart/numdart.dart';
import 'package:scidart/scidart.dart';
import 'package:scidart/src/numdart/numdart.dart';
import 'package:iirjdart/butterworth.dart';
import 'dart:ffi';


class EMGProcessingWidget extends StatefulWidget {
  @override
  _EMGProcessingWidgetState createState() => _EMGProcessingWidgetState();
}

class _EMGProcessingWidgetState extends State<EMGProcessingWidget> {
  List<List<dynamic>> csvData = [];
  int numContractions = 0;
  double totalContractionDuration = 0;
  double frequency = 0;
  double totalDuration = 0;

  @override
  void initState() {
    super.initState();
    loadCSV();
  }

  Future<void> loadCSV() async {
    String data = await rootBundle.loadString("assets/signals/valentina.csv");
    List<List<dynamic>> rowsAsListOfValues = CsvToListConverter().convert(data);
    setState(() {
      csvData = rowsAsListOfValues;
    });
    procesarEMG();
  }

  // void processCSVData() {
  //   List<double> sensor1Data = csvData.map((row) => row[1] as double).toList();
  //   // List<double> emg2 = csvData.map((row) => row[2]).cast<double>().toList();
  //
  //   double threshold = 0.05;
  //   bool isContraction = false;
  //   int contractionStartIndex = 0;
  //
  //   for (int i = 0; i < sensor1Data.length; i++) {
  //     if (sensor1Data[i] > threshold) {
  //       if (!isContraction) {
  //         isContraction = true;
  //         contractionStartIndex = i;
  //       }
  //     } else {
  //       if (isContraction) {
  //         isContraction = false;
  //         int contractionDuration = i - contractionStartIndex;
  //         totalContractionDuration += contractionDuration;
  //         numContractions++;
  //       }
  //     }
  //   }
  //
  //   double samplingRate = 100;
  //   double averageContractionDuration = totalContractionDuration / numContractions;
  //   // frequency = samplingRate / averageContractionDuration; //in Hz
  //   // frequency = (samplingRate / averageContractionDuration) * 60; //per minute
  //   totalContractionDuration = totalContractionDuration / samplingRate; //in seconds
  //   totalDuration = (sensor1Data.length / samplingRate) / 60; // total duration in mins
  //   frequency = numContractions / (totalDuration); // frequency in contractions per minute
  //   print(totalDuration);
  // }

  Future<void> procesarEMG() async {
    try {
      // Señales de EMG crudas
      // List<double> emg1 = csvData.map((row) => row[1] as double).toList();
      List<double> emg2 = csvData.map((row) => row[2]).cast<double>().toList();

      // Calculo la frecuencia
      int samples = emg2.length;
      double duration = 32.41; // Duration of the recording in minutes
      frequency = samples / (duration * 60);

      // Aplicar filtro pasa banda
      List<double> filteredEmg = filterEmg(emg2);

      // Calcular envolvente
      List<List<double>> envelopeCalc = calculateEnvelope(filteredEmg);
      List<double> absSignal = envelopeCalc[0];
      List<double> envelope = envelopeCalc[1];

      print("Señal Absoluta: $absSignal");
      print("Envolvente: $envelope");

      // Convertir List<num> a Array
      // Array<num> envelopeArray = Array<num>.from(envelope);

      // Detectar picos
      List<dynamic> peaks = findPeaks(Array(envelope), threshold: 0.16);
      int cantidadDePicos = peaks[1].length;

      // Imprimir resultados
      print("Peaks: $peaks");
      print("Cantidad de peaks: $cantidadDePicos");
    } catch (e) {
      print("Error: $e");
    }
  }

  List<double> filterEmg(List<double> emgSignal) {
    // // Define filter parameters
    // const double lowCutoff = 0.2;
    // const double highCutoff = 1.0;
    // const double sampleRate = 0.5 * 50;
    //
    // // Calculate normalized cutoff frequencies
    // double normalizedLowCutoff = lowCutoff / sampleRate;
    // double normalizedHighCutoff = highCutoff / sampleRate;

    int order = 2; // Orden del filtro (ajusta según tus necesidades)
    double sampleRate = 50.0; // Frecuencia de muestreo (ajusta según tus necesidades)
    double centerFrequency = 0.6; // Frecuencia central del filtro pasa banda (ajusta según tus necesidades)
    double widthFrequency = 0.8; // Ancho del filtro pasa banda (ajusta según tus necesidades)

    Butterworth butterworth = Butterworth();
    butterworth.bandPass(order, sampleRate, centerFrequency, widthFrequency);

    List<double> filteredData = [];
    for(var v in emgSignal) {
      filteredData.add(butterworth.filter(v));
    }

    print("filtered data: $filteredData");
    // Apply the filter to the EMG signal
    // List<double> filteredEmg = filtfilt(b, a, emgSignal);

    return filteredData;
    }

  List<List<double>> calculateEnvelope(List<double> signal, {double cutoffFreq = 0.0166}) {
    // Calcular el valor absoluto
    List<double> absSignal = signal.map((value) => value.abs()).toList();

    // Filtro pasa bajo de 0.0166 Hz para obtener la envolvente
    double fs = 50.0; // Ajusta según tu frecuencia de muestreo
    double nyquist = 0.5 * fs;
    double normalCutoff = cutoffFreq / nyquist;

    // Diseñar un filtro pasa bajo Butterworth
    Butterworth butterworth = Butterworth();
    butterworth.lowPass(1, fs, normalCutoff);

    // Aplicar el filtro a la señal absoluta
    List<double> envelope = absSignal.map((value) => butterworth.filter(value)).toList();

    return [absSignal, envelope];
  }



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('EMG Data Processor'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Total duration: $totalDuration',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Number of Contractions: $numContractions',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Average Contraction Duration: $totalContractionDuration seconds',
                style: TextStyle(fontSize: 20),
              ),
              Text(
                'Frequency: $frequency per minute',
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}




