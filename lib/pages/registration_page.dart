import 'package:flutter/material.dart';

import 'navigation_page.dart';
final _controller = TextEditingController();

class Registration1 extends StatefulWidget {
  @override
  State<Registration1> createState() => _Registration1State();
}

class _Registration1State extends State<Registration1> {
  @override



  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body: Padding(
        padding: const EdgeInsets.only(left: 45.0, right: 45.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Welcome!',
                style: TextStyle(color: Colors.grey[800], fontSize: 45, fontWeight: FontWeight.bold,  letterSpacing: 2.0),),
              Text('Create your account',
                style: TextStyle(color: Colors.grey[800], fontSize: 16, letterSpacing: 2.0),),
              const SizedBox(height: 40.0),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                //color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                  child: Column( children: [
                    ParameterWidget('NAME'),
                    const SizedBox(height: 20),
                    ParameterWidget('SURNAME'),
                    const SizedBox(height: 20),
                    ParameterWidget('EMAIL'),
                    const SizedBox(height: 20),
                    ParameterWidget('AGE'),
                    const SizedBox(height: 30),
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Colors.purple[100]),
                      ),
                      onPressed: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Registration2()));
                      },
                      child: Text(
                        '     Next     ',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 17.0,
                            letterSpacing: 1.0,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),


                  ],),
                ),
              )
            ],
          ),
        ),
      )
    );
  }
}

class Registration2 extends StatefulWidget {
  @override
  State<Registration2> createState() => _Registration2State();
}

class _Registration2State extends State<Registration2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.purple[100],
        body: Padding(
          padding: const EdgeInsets.only(left: 45.0, right: 45.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Welcome!',
                  style: TextStyle(color: Colors.grey[800], fontSize: 45, fontWeight: FontWeight.bold,  letterSpacing: 2.0),),
                Text('Create your account',
                  style: TextStyle(color: Colors.grey[800], fontSize: 16, letterSpacing: 2.0),),
                const SizedBox(height: 40.0),
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20.0))),
                  //color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                    child: Column( children: [
                      ParameterWidget('HOW MANY WEEKS', variable2: 'PREGNANT ARE YOU?'),
                      const SizedBox(height: 20),
                      ParameterWidget('NUMBER OF PREVIOUS', variable2:'PREGNANCIES'),
                      const SizedBox(height: 20),
                      ParameterWidget('HOW MANY CHILDREN ARE', variable2:'YOU EXPECTING?'),
                      const SizedBox(height: 20),
                      ParameterWidget('IS IT A HIGH-RISK PREGNANCY?'),
                      const SizedBox(height: 30),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(Colors.purple[100]),
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Navigation()));
                        },
                        child: Text(
                          '     Create account     ',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              letterSpacing: 1.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),


                    ],),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}


Widget ParameterWidget(var variable1,  {var variable2='0'}) {
  return Container(
    child: Column(
      children: [
        Row(
          children: [
            Text(variable1,
              style: TextStyle(
                  color: Colors.grey[700],
                  letterSpacing: 2.0,
                  fontSize: 15.0
              ),),
          ],),
        (variable2 != '0') ? Row(children: [
          Text(variable2, style: TextStyle( color: Colors.grey[700],  letterSpacing: 2.0,  fontSize: 15.0  ),)],) :
        const SizedBox(height: 7.0),
        // Container(
        //   height: 55,
        //   decoration: BoxDecoration(
        //       color: Colors.grey[300],
        //       borderRadius: const BorderRadius.all(Radius.circular(20.0))),
        // ),
        TextFormField(
          controller: _controller,
          decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[300],
              enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(color: Colors.white10),
              ),),
            ),
          ],)
        );
}

