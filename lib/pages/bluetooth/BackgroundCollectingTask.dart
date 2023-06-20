import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';

class DataSample{
  final double eje_x;
  final double eje_y;
  final double eje_z;

  final double red;
  final double ir;

  final DateTime timestamp;

  const DataSample({
    required this.eje_x,
    required this.eje_y,
    required this.eje_z,

    required this.red,
    required this.ir,

    required this.timestamp,

  });

  Map<String, dynamic> toJson(){
    return{
      "Eje X:": eje_x,
      "Eje Y:": eje_y,
      "Eje Z:": eje_z,
      "Rojo:": red,
      "IR:": ir,

    };
  }
}

class BackgroundCollectingTask extends Model {
  static BackgroundCollectingTask of(
    BuildContext context, {
    bool rebuildOnChange = true,
  }) =>
      ScopedModel.of<BackgroundCollectingTask>(
        context,
        rebuildOnChange: rebuildOnChange,
      );

  final BluetoothConnection _connection;
  final _db = FirebaseFirestore.instance;

  List<int> _buffer = List<int>.empty(growable: true);
  List<DataSample> samples = List<DataSample>.empty(growable: true);

  bool inProgress = false;

  BackgroundCollectingTask._fromConnection(this._connection) {
    _connection.input!.listen((data) { //aca lee lo que le manda el arduino
      //print(data);

      _buffer += data;
      //log('data: $data');
      //int len = data.length;
      //log('longitud: $len');

      while (true) {
        // If there is a sample, and it is full sent
        int index = _buffer.indexOf('a'.codeUnitAt(0));
        if (index >= 0 && _buffer.length - index >= 11) {
          print('Adentro IF');
          print(_buffer);
          final DataSample sample = DataSample(
              eje_x: ((_buffer[index + 1] + _buffer[index + 2] )/2 ),
              eje_y: ((_buffer[index + 3] + _buffer[index + 4]) /2),
              eje_z: ((_buffer[index + 5] + _buffer[index + 6] )/2),
              red: (1000*(_buffer[index + 7] + _buffer[index + 8] )/2),
              ir: (1000*(_buffer[index + 9] + _buffer[index + 10] )/2),

              timestamp: DateTime.now());

          // writeData(sample);
          _buffer.removeRange(0, index + 11);
          samples.add(sample);
          //print(samples);

          notifyListeners(); // Note: It shouldn't be invoked    very often - in this example data comes at every second, but if there would be more data, it should update (including repaint of graphs) in some fixed interval instead of after every sample.
          //print("${sample.timestamp.toString()} -> ${sample.temperature1} / ${sample.temperature2}");
        }
        // Otherwise break
        else {
          break;
        }
      }
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
    inProgress = true;
    _buffer.clear();
    samples.clear();
    notifyListeners();
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }

  Future<void> cancel() async {
    inProgress = false;
    notifyListeners();
    _connection.output.add(ascii.encode('stop')); //esto hay que ponerlo en una funcion de un boton para que mande
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
    print('despausa');
    _connection.output.add(ascii.encode('start'));
    await _connection.output.allSent;
  }

  Iterable<DataSample> getLastOf(Duration duration) {
    DateTime startingTime = DateTime.now().subtract(duration);
    int i = samples.length;
    do {
      i -= 1;
      if (i <= 0) {
        break;
      }
    } while (samples[i].timestamp.isAfter(startingTime));
    return samples.getRange(i, samples.length);
  }

  // Future<void> writeData(DataSample sample) async{
  //   _db.collection("datos_crudos").add(sample.toJson());
  // }
}
