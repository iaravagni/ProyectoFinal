import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'dart:io';
import 'package:provider/provider.dart';


import '../Resources/carousel_widget.dart';
import 'timer_provider.dart';
import 'bluetooth/BackgroundCollectingTask2.dart';
import 'bluetooth/SelectBondedDevicePage.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'report_page.dart';

class Record extends StatefulWidget {
  // final TimerProvider timerProvider;
  // const Record({Key? key, required this.timerProvider}): super(key: key);
  @override
  _Record createState() => new _Record();

}

bool stopButton = false;
class _Record extends State<Record> with AutomaticKeepAliveClientMixin {

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;    //definimos el estado inicial como unknown

  String _address = "...";
  String _name = "...";

  Timer? _discoverableTimeoutTimer;
  int _discoverableTimeoutSecondsLeft = 0;

  BackgroundCollectingTask? _collectingTask;


  bool connectButton = true;
  bool startButton = false;
  //bool stopButton = false;
  //bool downloadButton = false;
  bool newRecButton = false;
  bool timerButton = false;

  bool showPainLevelInput = false;
  int painLevel = 0; // Variable to store the pain level


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


  Future<void> showPainLevelDialog(BuildContext context, timerProvider) async {
    print(Theme.of(context).dialogBackgroundColor);

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                'Indicate Pain Level',
                style: TextStyle(
                  color: Colors.grey[700],
                  letterSpacing: 1.5,
                  fontSize: 20.0,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Slider(
                    value: painLevel.toDouble(),
                    min: 0,
                    max: 10,
                    divisions: 10,
                    onChanged: (double value) {
                      setState(() {
                        painLevel = value.round();
                      });
                    },
                    activeColor: Color(0xFF4c405c),
                    inactiveColor: Colors.grey[200],
                  ),
                  SizedBox(height: 10),
                  Text(
                    'PAIN LEVEL: $painLevel',
                    style: TextStyle(
                      color: Colors.grey[700],
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      startButton = true;
                      newRecButton = false;
                      //downloadButton = false;
                      timerButton = true;
                      timerProvider.reset();
                      //totalData = [];
                      Navigator.of(context).pop(true); // Close the dialog
                    });
                  },
                  child: Text(
                    'Submit',
                    style: TextStyle(
                      color: Color(0xFF4c405c),
                      letterSpacing: 1.5,
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }



  @override
  void dispose() {
    FlutterBluetoothSerial.instance.setPairingRequestHandler(null);
    _collectingTask?.dispose();
    _discoverableTimeoutTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final timerProvider = Provider.of<TimerProvider>(context);
    super.build(context);
    {
      return Scaffold(
        backgroundColor: Colors.purple[100],
        body: SafeArea(
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(top: 35.0, bottom: 20.0, left: 35.0, right: 35.0),
              child: Column(
                children: [
                  const Center(
                    child: Icon(
                      Icons.bluetooth_rounded,
                      color: Colors.white70,
                      size: 50.0,),
                  ),

                  const SizedBox(height: 10.0),

                  const Center(
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

                  const SizedBox(height: 15.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Enable Bluetooth',
                        style: TextStyle(
                            color: Colors.white, //Colors.grey[900],
                            letterSpacing: 2.0,
                            fontSize: 17.0
                        ),
                      ),
                      Switch(
                        activeColor: Colors.white70,
                        value: _bluetoothState.isEnabled,
                        // This bool value toggles the switch.
                        onChanged: (bool value) {
                          // Do the request and update with the true value then
                          future() async {
                            // async lambda seems to not working
                            if (value) {
                              await FlutterBluetoothSerial.instance
                                  .requestEnable();
                            } else {
                              await FlutterBluetoothSerial.instance
                                  .requestDisable();
                            }
                          }

                          future().then((_) {
                            setState(() {});
                          });
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 25.0),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0), // Adjust the value as needed
                      ),
                    ),
                    child: Container(
                        height: 100.0,
                        width: 100.0,
                        child: ((connectButton == false)
                            ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.leak_remove, size: 40.0, color: Color(0xFFFFFFFF),),
                              SizedBox(height: 5.0),
                              //Text('Disconnect'),
                              //Text('device')
                              Text('Disconnect', style: TextStyle(color: Color(0xFFFFFFFF)),),
                              Text('device', style: TextStyle(color: Color(0xFFFFFFFF)),)
                            ])
                            : const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.leak_add, size: 40.0, color: Color(0xFFFFFFFF),),
                              SizedBox(height: 5.0),
                              Text('Connect', style: TextStyle(color: Color(0xFFFFFFFF)),),
                              Text('device', style: TextStyle(color: Color(0xFFFFFFFF)),)
                            ]))
                    ),
                    onPressed: () async {
                      if (_bluetoothState.isEnabled == false) {
                        showDialog(
                          context: context,
                          builder: (context) =>
                          const AlertDialog(
                            title: Text('Aviso'),
                            content: Text(
                                'Bluetooth must be on to connect a device.'),
                          ),
                        );
                      }
                      else {
                        // if (_collectingTask?.inProgress ??
                        //     false || connectButton == false) {
                        if (connectButton == false) {
                          await _collectingTask!.disconnect();
                          newRecButton = false;
                          startButton = false;
                          stopButton = false;
                          connectButton = true;
                          timerButton = false;
                          timerProvider.stop();
                          timerProvider.reset();
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
                            newRecButton = true;
                            //startButton = true;
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

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     ElevatedButton(
                  //       child: Container(
                  //           height: 100.0,
                  //           width: 100.0,
                  //           child: Column(
                  //             mainAxisAlignment: MainAxisAlignment.center,
                  //             children: [
                  //               Icon(Icons.add_link_rounded, size: 40.0,),
                  //               const SizedBox(height: 5.0),
                  //               Text('Pair new'),
                  //               Text('device')],
                  //           )
                  //       ),
                  //       onPressed: () {
                  //         FlutterBluetoothSerial.instance.openSettings();
                  //       },
                  //
                  //       style: ElevatedButton.styleFrom(
                  //           backgroundColor: Colors.purple[50]),
                  //     ),
                  //
                  //     const SizedBox(width: 20.0),
                  //
                  //     ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           backgroundColor: Colors.purple[50]),
                  //       child: Container(
                  //           height: 100.0,
                  //           width: 100.0,
                  //           child: ((connectButton == false)
                  //               ? Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Icon(Icons.leak_remove, size: 40.0,),
                  //                 const SizedBox(height: 5.0),
                  //                 Text('Disconnect'),
                  //                 Text('device')
                  //               ])
                  //               : Column(
                  //               mainAxisAlignment: MainAxisAlignment.center,
                  //               children: [
                  //                 Icon(Icons.leak_add, size: 40.0,),
                  //                 const SizedBox(height: 5.0),
                  //                 Text('Connect'),
                  //                 Text('device')
                  //               ]))
                  //       ),
                  //       //inProgress = false
                  //       onPressed: () async {
                  //         if (_bluetoothState.isEnabled == false) {
                  //           showDialog(
                  //             context: context,
                  //             builder: (context) =>
                  //             const AlertDialog(
                  //               title: Text('Aviso'),
                  //               content: Text(
                  //                   'Bluetooth must be on to connect a device.'),
                  //             ),
                  //           );
                  //         }
                  //         else {
                  //           if (_collectingTask?.inProgress ??
                  //               false || connectButton == false) {
                  //             await _collectingTask!.cancel();
                  //             stopButton = false;
                  //             connectButton = true;
                  //             setState(() {
                  //               /* Update for `_collectingTask.inProgress` */
                  //             });
                  //           } else {
                  //             final BluetoothDevice? selectedDevice =
                  //             await Navigator.of(context).push(
                  //               MaterialPageRoute(
                  //                 builder: (context) {
                  //                   return const SelectBondedDevicePage(
                  //                       checkAvailability: false);
                  //                 },
                  //               ),
                  //             );
                  //             if (selectedDevice != null) {
                  //               await _startBackgroundTask(
                  //                   context, selectedDevice);
                  //               startButton = true;
                  //               connectButton = false;
                  //               setState(() {
                  //                 /* Update for `_collectingTask.inProgress` */
                  //               });
                  //               //_collectingTask?.inProgress = true;
                  //             }
                  //           }
                  //         }
                  //       },
                  //     ),
                  //   ],
                  // ),

                  SizedBox(height: 20.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [((connectButton == false) ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.check, size: 15.0, color: Colors.green),
                          Text(' Device paired',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 1.5,
                                fontStyle: FontStyle.italic,
                                fontSize: 15.0),),
                        ])
                        : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          Icon(Icons.close, size: 15.0,color: Colors.red),
                          Text(' Device unpaired',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 1.5,
                                fontStyle: FontStyle.italic,
                                fontSize: 15.0),),
                        ]))
                    ],),
                ],),
            ),

            Expanded(
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    // ElevatedButton(
                    //   onPressed: () {
                    //     _showPainLevelDialog(context); // Show the pain level dialog
                    //   },
                    //   child: Text('Indicate pain level',
                    //   style: TextStyle(
                    //       color: Colors.white,
                    //       fontSize: 18.0,
                    //       letterSpacing: 1.0,
                    //       fontWeight: FontWeight.bold
                    //   ))
                    //
                    // ),

                    // const SizedBox(height: 10.0),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        MyImageCarouselWidget(),
                        const SizedBox(width: 20,)
                      ],
                    ),

                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        ),
                        backgroundColor: MaterialStateColor.resolveWith((states) {
                          if (states.contains(MaterialState.disabled)) {
                            return Colors.grey[300]!;
                          }
                          return const Color(0xFF4c405c);
                        }),
                      ),
                      onPressed: (newRecButton == true) ? () async {
                        await showPainLevelDialog(context, timerProvider);
                        setState(() {});
                      } : null,
                      child: Text(
                        'NEW RECORDING',
                        style: TextStyle(
                          color: (newRecButton == true) ? Colors.white : Colors.grey[550], // Change the text color
                          fontSize: 15.0,
                          letterSpacing: 2.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    Center(
                    child: stopButton ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.fiber_manual_record,
                            color: Colors.red,
                            size: 15,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Recording...',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 1.5,
                                fontStyle: FontStyle.italic,
                                fontSize: 15.0),
                          ),
                      ],) : Text('')
                    ),

                    SizedBox(height: 10),

                    if (timerButton) ...[
                      Text(
                        timerProvider.formatTime(),
                        style: TextStyle(
                          color: Colors.grey[700],
                          letterSpacing: 2.0,
                          fontSize: 40.0,
                        ),
                      ),
                    ],

                    const SizedBox(height: 15.0),

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
                                child: Icon(Icons.play_arrow_rounded, size: 40.0, color: startButton ? Colors.white : null),
                                onPressed: (startButton == true) ? () async {
                                  await _startRecording();
                                  startButton = false;
                                  stopButton = true;
                                  downloadButton = false;
                                  timerProvider.start();
                                  setState(() {});
                                } : null,
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
                                child: Icon(Icons.stop_rounded, size: 40.0, color: stopButton ? Colors.white : null),
                                onPressed: (stopButton == true) ? () async {
                                  timerProvider.stop();
                                  await _stopRecording();
                                  await saveCSVFile(totalData, painLevel, timerProvider.formatTime());
                                  newRecButton = true;
                                  stopButton = false;
                                  //newRecButton = true;
                                  startButton = false;
                                  downloadButton = true;
                                  setState(() {});
                                } : null,
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

                    // const SizedBox(height: 10.0),

                    // Center(
                    //   child: ElevatedButton(
                    //     style: ElevatedButton.styleFrom(
                    //         backgroundColor: Colors.purple[100],
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(100),
                    //         )),
                    //     child: Icon(Icons.download, size: 40.0),
                    //     onPressed: (downloadButton == true) ? () async {
                    //       await saveCSVFile(totalData, painLevel);
                    //       setState(() {});();
                    //     } : null,
                    //   ),
                    // ),


                  ],
                ),
              ),
            ),
          ],),
        ),
      );
    };
  }


  Future<void> _startRecording() async {
    await _collectingTask?.start();
  }

  Future <void> _stopRecording() async {
    await _collectingTask!.cancel();
    print('Recording stopped');
  }


  Future<void> saveCSVFile(List<double> csvData, int painLevel, String duration) async {
    final List<List<dynamic>> csvContent = [];

    for (int i = 0; i < csvData.length; i += 2) {
      final List<dynamic> row = [
        painLevel,
        csvData[i],
        csvData[i + 1],
        duration,

      ];
      csvContent.add(row);
    }

    final Directory? directory = await getExternalStorageDirectory();
    final file = File('${directory?.path}/${DateTime.now()} - Medicion EHG.csv');

    final csvFileContent = const ListToCsvConverter().convert(csvContent);
    await file.writeAsString(csvFileContent);

    print('CSV file with data and pain level saved at: ${file.path}');
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


  @override
  bool get wantKeepAlive => true;
}