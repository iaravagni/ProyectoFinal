import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Reports extends StatefulWidget {
  const Reports({Key? key}) : super(key: key);

  @override
  State<Reports> createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {


  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Report'),
      backgroundColor: Colors.purple,
        ),
    body: Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children:[
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('Resultados').orderBy("TS",descending: true).limit(1).snapshots() ,
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(snapshot.hasError){
                return Center(
                  child: CircularProgressIndicator()
                );
              }
              return Container(
                height: MediaQuery.of(context).size.height/2,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  children: snapshot.data!.docs.map((snap){
                    return Card(
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            title: Text(
                              'Sleep Duration:'+ snap['Duracion'].toString(),
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),),
                          ),
                          Divider(),
                          ListTile(
                            title: Text(
                              'Sleep Stages',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget> [
                              CircularPercentIndicator(
                                radius: 45.0,
                                animation: true,
                                animationDuration: 1200,
                                lineWidth: 4.3,
                                percent: 0.10,
                                header: const Text('Light Sleep'),
                                center: Text(snap['LS'].toString()),
                                progressColor: Colors.red,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                              ),
                              CircularPercentIndicator(
                                radius: 45.0,
                                animation: true,
                                animationDuration: 1200,
                                lineWidth: 4.3,
                                percent: 0.30,
                                header: const Text('Deep Sleep'),
                                center: Text(snap['DS'].toString()),
                                progressColor: Colors.green,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                              ),
                              CircularPercentIndicator(
                                radius: 45.0,
                                animation: true,
                                animationDuration: 1200,
                                lineWidth: 4.3,
                                percent: 0.60,
                                header: const Text('Awake'),
                                center: Text(snap['AW'].toString()),
                                progressColor: Colors.yellow,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10.0),
                              ),
                              //const Padding(
                              //  padding: EdgeInsets.symmetric(vertical: 5.0),
                              // ),
                            ],
                          ),

                          ListTile(title: Text(
                            'Vital Signs',
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.monitor_heart_outlined),
                            title: Text('Heart Rate' + snap['FC'].toString() ?? '0'),
                          ),
                          ListTile(
                            leading: Icon(Icons.medical_information_outlined),
                            title: Text('Breath Rate' + snap['FR'].toString() ?? '0'),
                          ),
                          ListTile(
                              leading: Icon(Icons.sanitizer_outlined),
                              title:  Text('SpO2' + snap['SpO2'].toString() ?? '0')
                          ),
                          //const Padding(
                          // padding: EdgeInsets.symmetric(vertical: 5.0),
                          //),
                          ListTile(
                            title: Text(
                              'Anomalies',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                              ),),
                          ),
                          Divider(),
                          ListTile(
                            leading: Icon(Icons.monitor_heart_outlined),
                            title:  Text('AF'+ snap['AF'].toString()),
                          ),
                          ListTile(
                            leading: Icon(Icons.medical_information_outlined),
                            title: Text('PVC' + snap['PVC'].toString()),
                          ),
                          ListTile(
                              leading: Icon(Icons.sanitizer_outlined),
                              title: Text('Bradycardia' + snap['Bradicardia'].toString())
                          ),
                          ListTile(
                              leading: Icon(Icons.sanitizer_outlined),
                              title: Text('Tachycardia' + snap['Taquicardia'].toString())
                          ),

                        ]
                      ),
                    );
                  }).toList()
                ),
              );
            },),
            ]),
    ),
  );
}

