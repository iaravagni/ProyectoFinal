import 'package:flutter/material.dart';
import '../Resources/my_clipper.dart';

class History extends StatefulWidget{

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,

        body: Stack(
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
                                  Icons.history,
                                  color: Colors.white70,
                                  size: 50.0,),
                              ),


                              const SizedBox(height: 10.0),

                              Center(
                                child: Text(
                                  'History',
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
                      ],
                  ),
              ),
            ],
        ),
    );
  }
}