import 'package:flutter/material.dart';
import '../Resources/my_clipper.dart';
import 'package:percent_indicator/percent_indicator.dart';

class Report extends StatefulWidget{

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      body:  Stack(
        children: [
          Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.purple[100],
                    child: Column(
                        children: [
                          const SizedBox(height: 55.0),
                          Center(
                            child: Icon(
                              Icons.receipt_long_rounded,
                              color: Colors.white70,
                              size: 50.0,),
                          ),


                      const SizedBox(height: 10.0),

                      Center(
                        child: Text(
                          'Last Report',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2.0,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      const SizedBox(height: 20.0),
                      ],),),

                const SizedBox(height: 70.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(60.0,0.0,60.0,0.0),
                  child: Column( children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'NUMBER OF',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                          Text(
                            'DURATION OF',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CONTRACTIONS',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                          Text(
                            'CONTRACTIONS',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 120.0,
                            width: 140.0,
                            decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: const BorderRadius.all(Radius.circular(20.0))),
                            child: Center(
                              child: Text(
                                '-', //TODO: Change to variable user.pregnancies
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    letterSpacing: 2.0,
                                    fontSize: 50.0
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 120.0,
                            width: 140.0,
                            decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: const BorderRadius.all(Radius.circular(20.0))),
                            child: Center(
                              child: Text(
                                '-', //TODO: Change to variable user.children
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    letterSpacing: 2.0,
                                    fontSize: 50.0
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'TIME BETWEEN',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                          Text(
                            'CONTRACTIONS',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CONTRACTIONS',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                          Text(
                            'INTENSITY',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 120.0,
                            width: 140.0,
                            decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: const BorderRadius.all(Radius.circular(20.0))),
                            child: Center(
                              child: Text(
                                '-', //TODO: Change to variable user.risk
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    letterSpacing: 2.0,
                                    fontSize: 50.0
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 120.0,
                            width: 140.0,
                            decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: const BorderRadius.all(Radius.circular(20.0))),
                            child: Center(
                              child: Text(
                                '-', //TODO: Change to variable user.reports
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    letterSpacing: 2.0,
                                    fontSize: 50.0
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 100.0),

                      // Text(
                      //   'LABOR RISK LEVEL',
                      //   style: TextStyle(
                      //       color: Colors.grey[700],
                      //       letterSpacing: 2.0,
                      //       fontSize: 15.0
                      //   ),
                      // ),
                      //
                      // const SizedBox(height: 20.0),
                      //
                      // LinearPercentIndicator(
                      //   //width: MediaQuery.of(context).size.width - 50,
                      //   animation: true,
                      //   lineHeight: 20.0,
                      //   animationDuration: 2500,
                      //   percent: 0.8,
                      //   center: Text("80.0%"),
                      //   linearStrokeCap: LinearStrokeCap.roundAll,
                      //   progressColor: Colors.orangeAccent,
                      // ),


                    ],
                  ),
              ),

            ],),
          ),],
      ),
    );

  }
}