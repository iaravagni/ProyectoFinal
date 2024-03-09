import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';
import '../signal_processing.dart';
import '../report_page.dart';

List<double> totalData = [];

class BackgroundCollectingTask extends Model {
  static BackgroundCollectingTask of(
      BuildContext context, {
        bool rebuildOnChange = true,
      }) =>
      ScopedModel.of<BackgroundCollectingTask>(
        context,
        rebuildOnChange: rebuildOnChange,
      );

  bool packageStarted = false;
  List<int> packageData = [];
  final BluetoothConnection _connection;

  bool inProgress = false;

  BackgroundCollectingTask._fromConnection(this._connection) {
    _connection.input?.listen((List<int> data) {
      //print('Received data: $data');
      data.forEach((byte) {
        // print('Processing byte: $byte');
        if (byte == 'A'.codeUnitAt(0)) {

          // Start of package identifier
          print('Package start');
          if (!packageStarted){
          packageData.clear();
          packageStarted = true;}
        } else if (byte == 'Z'.codeUnitAt(0) && packageStarted && packageData.length>=200) {

          // End of package identifier
          print('Package end');
          //print(packageData.length);
          packageStarted = false;

          // Process the complete package
          int bufferLength = 200;

          if (packageData.length == bufferLength) {
              totalData.addAll(_processPackage(packageData));
              //print('Total data: $totalData');

              //print('Total data length:');
              //print(totalData.length);
              // print('Package: $packageData');
          }
        } else {
          if (packageStarted) {
            packageData.add(byte);
          }
        }
      });
    }).onDone(() {
      inProgress = false;
      notifyListeners();
    });
  }

  static Future<BackgroundCollectingTask> connect(
      BluetoothDevice server) async {
    final BluetoothConnection connection =
    await BluetoothConnection.toAddress(server.address);
    return BackgroundCollectingTask._fromConnection(connection);
  }

  void dispose() {
    _connection.dispose();
  }

  Future<void> start() async {
    print("entre al start");
    totalData.clear();
    totalDataEmg1.clear();
    totalDataEmg2.clear();
    lastSampleIndex = 0;
    lastSampleDuration = Duration(seconds: 0);
    totalPeaks.clear();
    totalPeaksWidths.clear();
    totalPeaksIntensity.clear();

    durationValue = '-';
    frequencyValue = '-';
    intensityValue = '-';
    numContractions = '-';

    lastUpdate = '-';

    lastSecond = 0;


    inProgress = true;
    notifyListeners();
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }

  Future<void> cancel() async {
    inProgress = false;
    notifyListeners();
    _connection.output.add(ascii.encode('stop')); //esto hay que ponerlo en una funcion de un boton para que mande
    //await _connection.finish();
  }

  Future<void> disconnect()async{
    await _connection.finish();
  }

  Future<void> pause() async {
    inProgress = false;
    notifyListeners();
    print('pausa');
    _connection.output.add(ascii.encode('stop'));
    await _connection.output.allSent;
  }

  Future<void> resume() async {
    inProgress = true;
    notifyListeners();
    print('resume');
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }

  List<double> _processPackage(List<int> package) {
    List<double> receivedData = [];

    for (int i = 0; i < package.length; i += 2) {
      int highByte = package[i];
      int lowByte = package[i + 1];
      int combinedValue = (highByte <<
          8) | lowByte; // Combine the high and low bytes correctly
      double originalReading = combinedValue *
          (5.0 / 1023.0); // Convert the combined value to the original reading
      double roundedValue = (originalReading * 1000).round() /
          1000; // Round to 3 decimal places
      receivedData.add(roundedValue);
    }

    print('Received data: $receivedData');

    return receivedData;
  }
}