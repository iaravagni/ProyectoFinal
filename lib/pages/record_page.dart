import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'dart:io';

import 'bluetooth/BackgroundCollectingTask2.dart';
import 'bluetooth/SelectBondedDevicePage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Record extends StatefulWidget {
  @override
  _Record createState() => new _Record();
}

class _Record extends State<Record> {

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;    //definimos el estado inicial como unknown

  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  BackgroundCollectingTask? _collectingTask;

  //bool _autoAcceptPairingRequests = false;

  bool connectButton = true;
  bool startButton = false;
  bool stopButton = false;
  bool downloadButton = false;

  //bool device = false;
  bool start = false;
  //bool stop = false;
  //bool collec = false;

  Timer? _timer;
  int _start = 40;

  double counter = 0;
  bool isCounting = false;
  late Timer timer;

  void startCounter() {
    setState(() {
      counter = 0;
      isCounting = true;
    });

    // Start the counter
    timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        counter += 0.01;
      });
    });
  }

  void stopCounter() {
    setState(() {
      isCounting = false;
    });

    // Stop the counter
    timer.cancel();
  }

  String formatTime(double time) {
    final minutes = time ~/ 60;
    final seconds = (time % 60).toStringAsFixed(2);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.padLeft(5, '0')}';
  }

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
      backgroundColor: Colors.purple[100],
      body: SafeArea(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              children: [
                Center(
                  child: Icon(
                    Icons.bluetooth,
                    color: Colors.white70,
                    size: 50.0,),
                ),

                const SizedBox(height: 10.0),

                Center(
                  child: Text(
                    'Bluetooth connection',
                    style: TextStyle(
                      color: Colors.white, //Colors.grey[900],
                      letterSpacing: 2.0,
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),

                const SizedBox(height: 50.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Enable Bluetooth',
                      style: TextStyle(
                          color: Colors.white ,//Colors.grey[900],
                          letterSpacing: 2.0,
                          fontSize: 17.0
                      ),
                    ),
                    Switch(
                      activeColor: Colors.white70,
                      value: _bluetoothState.isEnabled, // This bool value toggles the switch.
                      onChanged: (bool value) {
                        // Do the request and update with the true value then
                        future() async {
                          // async lambda seems to not working
                          if (value) {
                            await FlutterBluetoothSerial.instance.requestEnable();
                          } else {
                            await FlutterBluetoothSerial.instance.requestDisable();
                          }
                        }

                        future().then((_) {
                          setState(() {});
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30.0),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      child: Container(
                          height: 100.0,
                          width: 100.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_link_rounded, size: 40.0,),
                              const SizedBox(height: 5.0),
                              Text('Pair new'),
                              Text('device')],
                          )
                      ),
                      onPressed: () {
                        FlutterBluetoothSerial.instance.openSettings();
                      },

                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[50]),
                    ),

                    const SizedBox(width: 20.0),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.purple[50]),
                      child: Container(
                          height: 100.0,
                          width: 100.0,
                          child:((connectButton == false)
                              ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.leak_remove, size: 40.0,),const SizedBox(height: 5.0),Text('Disconnect'), Text('device')])
                              : Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.leak_add, size: 40.0,),const SizedBox(height: 5.0),Text('Connect'), Text('device')])                              )
                      ),
                      //inProgress = false
                      onPressed: () async {
                        if (_bluetoothState.isEnabled == false){
                          showDialog(
                            context: context,
                            builder: (context) => const AlertDialog(
                              title: Text('Aviso'),
                              content: Text('Bluetooth must be on to connect a device.'),
                            ),
                          );
                        }
                        else{
                          if (_collectingTask?.inProgress ?? false || connectButton == false) {
                            await _collectingTask!.cancel();
                            stopButton = false;
                            connectButton = true;
                            setState(() {
                              /* Update for `_collectingTask.inProgress` */
                            });
                          } else {
                            final BluetoothDevice? selectedDevice =
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return const SelectBondedDevicePage(
                                      checkAvailability: false);
                                },
                              ),
                            );
                            if (selectedDevice != null) {
                              await _startBackgroundTask(context, selectedDevice);
                              startButton = true;
                              connectButton = false;
                              setState(() {
                                /* Update for `_collectingTask.inProgress` */
                              });
                              //_collectingTask?.inProgress = true;
                            }
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],),
          ),

          Expanded(
            child: Container(
              color: Colors.white,
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 30.0),

                  Text(
                  formatTime(counter),
                  style: TextStyle(
                      color: Colors.grey[700],
                      letterSpacing: 2.0,
                      fontSize: 40.0),
                  ),

                  const SizedBox(height: 40.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  )),
                              child: Icon(Icons.play_arrow, size:40.0),
                              onPressed:  (startButton == true) ? () async {
                                await _startRecording();
                                startButton = false;
                                stopButton = true;
                                downloadButton = false;
                                startCounter;
                                // startTimer();
                                setState(() {});
                              }:null,
                            ),),

                          const SizedBox(height: 10.0),

                          Text('START',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 15.0),),
                          Text('RECORDING',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 15.0),),
                        ],),

                      const SizedBox(width: 60.0),

                      Column(
                        children: [
                          SizedBox(
                            height: 100,
                            width: 100,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(100),
                                  )),
                              child: Icon(Icons.stop, size:40.0),
                              onPressed: (stopButton == true) ?  () async{
                                stopButton = false;
                                startButton = true;
                                downloadButton = true;
                                stopCounter;
                                await _stopRecording();
                                initState();
                              }:null,
                            ),
                          ),

                          const SizedBox(height: 10.0),

                          Text('STOP',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 15.0),),
                          Text('RECORDING',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 15.0),),

                        ],),
                    ],
                  ),

                  const SizedBox(height: 30.0),

                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple[100],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          )),
                      child: Icon(Icons.download, size:40.0),
                      onPressed: (downloadButton == true) ?  () async{
                        await saveCSVFile(totalData);
                        initState();
                      }:null,
                    ),
                  ),

                  //BOTONES DE PRUEBA QUE HAY QUE BORRAR
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: isCounting ? null : startCounter,
                          child: Text('Start'),
                        ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: isCounting ? stopCounter : null,
                          child: Text('Stop'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],),
      ),
    );
  }

  // void startTimer() {
  //   const oneSec = Duration(seconds: 1);
  //   _timer = Timer.periodic(
  //     oneSec,
  //         (Timer timer) {
  //       if (_start == 0) {
  //         setState(() {
  //           timer.cancel();
  //         });
  //       } else {
  //         setState(() {
  //           _start--;
  //         });
  //       }
  //     },
  //   );
  //
  // }

  Future<void> _startRecording() async {
    await _collectingTask?.start();
  }

  Future <void> _stopRecording() async {
    await _collectingTask!.cancel();
    print('Recording stopped');
  }


  Future<void> saveCSVFile(List<double> csvData) async {
    final csvContent = csvData.map((value) => [value]).toList();

    final Directory? directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/${DateTime.now()} - Medicion EHG.csv');
    await file.writeAsString(const ListToCsvConverter().convert(csvContent));

    print('CSV file saved in the internal memory at: ${file.path}');
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
            content: Text(ex.toString()),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
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
}