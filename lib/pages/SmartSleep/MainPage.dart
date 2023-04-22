import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:scoped_model/scoped_model.dart';

import 'BackgroundCollectedPage.dart';
import '../bluetooth/BackgroundCollectingTask.dart';
import '../bluetooth/SelectBondedDevicePage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class MainPage2 extends StatefulWidget {
  @override
  _MainPage2 createState() => new _MainPage2();
}

class _MainPage2 extends State<MainPage2> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;    //definimos el estado inicial como unknown

  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  BackgroundCollectingTask? _collectingTask;

  //bool _autoAcceptPairingRequests = false;

  bool botonConnect = false;
  bool BotonStart = false;
  bool BotonStart2 = false;

  bool device = false;
  bool start = false;
  bool stop = false;
  bool collec = false;

  Timer? _timer;
  int _start = 40;

  //late final BluetoothConnection _connection; //trackear la conexion del blu con el celular

  @override
  void initState() {
    super.initState();

    // Analizamos el estado y lo definimos en la variable _bluetoothState
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    Future.doWhile(() async {
      // Wait if adapter not enabled
      if ((await FlutterBluetoothSerial.instance.isEnabled) ?? false) {
        return false;
      }
      await Future.delayed(Duration(milliseconds: 0xDD));
      return true;
    }).then((_) {
      // Update the address field
      FlutterBluetoothSerial.instance.address.then((address) {
        setState(() {
          _address = address!;
        });
      });
    });

    FlutterBluetoothSerial.instance.name.then((name) {
      setState(() {
        _name = name!;
      });
    });

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;

        // Discoverable mode is disabled when Bluetooth gets disabled
        _discoverableTimeoutTimer = null;
        _discoverableTimeoutSecondsLeft = 0;
      });
    });
  }

  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Sleep'),
      ),
      body: Container(
        child: ListView(
          children: <Widget>[
            Divider(),
            ListTile(title: const Text('Bluetooth Connection')),
            SwitchListTile(
              title: const Text('Enable Bluetooth'),
              value: _bluetoothState.isEnabled,
              onChanged: (bool value) {
                // Do the request and update with the true value then
                future() async {
                  // async lambda seems to not working
                  if (value)
                    await FlutterBluetoothSerial.instance.requestEnable();
                  else
                    await FlutterBluetoothSerial.instance.requestDisable();
                }

                future().then((_) {
                  setState(() {});
                });
              },
            ),

            ListTile(
              title: const Text('Bluetooth status'),
              subtitle: Text(_bluetoothState.toString()),
              trailing: ElevatedButton(
                 child: const Text('Settings'),
                onPressed: () {
                  FlutterBluetoothSerial.instance.openSettings();
                 },
              ),
            ),
            Divider(),
            ListTile(title: const Text('Connect to the device')),
              ListTile(
                title: ElevatedButton(
                  child: ((_collectingTask?.inProgress ?? false)
                    ? const Text('Disconnect Device') //inProgress = true
                    : const Text('Explore discovered devices')), //inProgress = false
                onPressed: () async {
                    if (_bluetoothState.isEnabled == false){
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Aviso'),
                            content: Text('No puede buscar dispositivos porque no tiene el bluetooth conectado.'),
                          ),
                      );
                    }
                    else{
                  if (_collectingTask?.inProgress ?? false) {
                    await _collectingTask!.cancel();
                    setState(() {
                      /* Update for `_collectingTask.inProgress` */
                    });
                  } else {
                    final BluetoothDevice? selectedDevice =
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return SelectBondedDevicePage(
                              checkAvailability: false);
                        },
                      ),
                    );
                    if (selectedDevice != null) {
                      await _startBackgroundTask(context, selectedDevice);
                      BotonStart = true;
                      setState(() {
                        /* Update for `_collectingTask.inProgress` */
                      });
                      //_collectingTask?.inProgress = true;
                    }
                  }
                  }
                },
              ),
            ),
            // Para mi aca no te deberia llevar a otra pagina si no mandarle un 1 al blu
            ListTile(
              title: ElevatedButton (
                  child: const Text('Start Recording'),
                  onPressed:  (BotonStart != false) ? () async {
                    await _startRecording();
                    BotonStart2 = true;
                    startTimer();
                    setState(() {});
                    }:null,
                  ),
                ),
              //),
            ListTile(
              title: ElevatedButton(
                child: const Text('Stop Recording'),
                onPressed: (BotonStart2 == true) ?  () async{
                await _stopRecording();
                fetchAlbum();
                initState();
               // final response = await http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

                }:null,
              ),
            ),
            ListTile(
              title: ElevatedButton(
                child: const Text('View realtime data'),
                onPressed:  /*( ( _start ==0 ? true:false ) &&*/ (BotonStart2 == true) ? (){
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ScopedModel<BackgroundCollectingTask>(
                          model: _collectingTask!,
                          child: BackgroundCollectedPage(),
                        );
                      },
                    ),
                  );
                }
                    : null
              ),
            ),
        ]
        ),
      )
    );
  }

  void startTimer() {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

   Future<void> _startRecording() async {
    await _collectingTask?.start();
   }

  Future <void> _stopRecording() async {
    await _collectingTask!.cancel();
  }

  Future<void> _startBackgroundTask(
      BuildContext context,
      BluetoothDevice server,
      ) async {
    try {
      _collectingTask = await BackgroundCollectingTask.connect(server);
      //await _collectingTask!.start();
    } catch (ex) {
      _collectingTask?.cancel();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Error occured while connecting'),
            content: Text("${ex.toString()}"),
            actions: <Widget>[
              new TextButton(
                child: new Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

  }

  Future <void> deleteData() async{
    var collection = FirebaseFirestore.instance.collection('datos crudos');
    var snapshots = await collection.get();
    for (var doc in snapshots.docs) {
      await doc.reference.delete();
    }
  }

  // Future<http.Response> fetchAlbum() async{
  //   return http.get(Uri.parse('http://scerretini.pythonanywhere.com/'));
  // }


  // Future<http.Response> fetchAlbum() {
  //   return http.get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));}

  Future<Album> fetchAlbum() async {
    final response = await http.get(Uri.parse('http://scerretini.pythonanywhere.com/'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return Album.fromJson(jsonDecode(response.body));
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

}

class Album {
  final int userId;
  final int id;
  final String title;

  const Album({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }
}
