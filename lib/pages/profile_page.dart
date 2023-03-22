import 'package:flutter/material.dart';
import '../Resources/my_clipper.dart';

class Profile extends StatefulWidget{

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      body:  Stack(
        children: [
          ClipPath(
              clipper: MyClipper(),
              child: Container(
                color: Colors.purple[100],
              )
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(60.0,70.0,60.0,0.0),
            child: Container(
              child: Column(

                children: <Widget>[
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          'Jane', //TODO: Change to variable user.name
                          style: TextStyle(
                            color: Colors.white, //Colors.grey[900],
                            letterSpacing: 2.0,
                            fontSize: 45.0,
                          ),
                        ),
                        SizedBox(width: 5.0),

                        Text(
                          'DOE', //TODO: Change to variable user.surname
                          style: TextStyle(
                            color: Colors.white,//Colors.grey[900],
                            letterSpacing: 2.0,
                            fontSize: 45.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 15.0),

                  const Center(
                    child: Text(
                      '27 weeks pregnant', //TODO: Change to variable user.weeks
                      style: TextStyle(
                          color: Colors.white ,//Colors.grey[900],
                          letterSpacing: 2.0,
                          fontSize: 18.0
                      ),
                    ),
                  ),


                  const SizedBox(height: 100.0),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PREVIOUS',
                        style: TextStyle(
                            color: Colors.grey[700],
                            letterSpacing: 2.0,
                            fontSize: 12.0
                        ),
                      ),
                      Text(
                        'CHILDREN',
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
                        'PREGNANCIES',
                        style: TextStyle(
                            color: Colors.grey[700],
                            letterSpacing: 2.0,
                            fontSize: 12.0
                        ),
                      ),
                      Text(
                        'EXPECTING',
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
                            '0', //TODO: Change to variable user.pregnancies
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
                            '1', //TODO: Change to variable user.children
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
                        'PREGNANCY',
                        style: TextStyle(
                            color: Colors.grey[700],
                            letterSpacing: 2.0,
                            fontSize: 12.0
                        ),
                      ),
                      Text(
                        'SAVED',
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
                        'RISK',
                        style: TextStyle(
                            color: Colors.grey[700],
                            letterSpacing: 2.0,
                            fontSize: 12.0
                        ),
                      ),
                      Text(
                        'REPORTS',
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
                            'LOW', //TODO: Change to variable user.risk
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
                            '3', //TODO: Change to variable user.reports
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
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.purple[100]),
                    ),
                    onPressed: () {}, //TODO: function to change page to edit information page
                    child: Text(
                      '     Edit information     ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 17.0,
                          letterSpacing: 1.0,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                  ),


                ],
              ),

            ),
          ),
        ],
      ),
    );

  }
}