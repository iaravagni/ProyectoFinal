import 'package:flutter/material.dart';
import 'package:myapp/pages/google_sign_in_page.dart';
import 'package:myapp/pages/login_page.dart';
import '../Resources/my_clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class Profile extends StatefulWidget{

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

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
            padding: const EdgeInsets.only(top: 75.0),
            child: Container(
              child: Column(
                children: <Widget>[
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(user.photoURL!),
                        ),

                        const SizedBox(width: 10),

                        Text(
                          user.displayName!, //TODO: Change to variable user.name
                          style: const TextStyle(
                            color: Colors.white, //Colors.grey[900],
                            letterSpacing: 2.0,
                            fontSize: 35.0,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),


                  const SizedBox(height: 70.0),

                  const Center(
                    child: Text(
                      '27 weeks pregnant', //TODO: Change to variable user.weeks
                      style: TextStyle(
                          color: Colors.black87,
                          letterSpacing: 2.0,
                          fontSize: 20.0
                      ),
                    ),
                  ),


                  const SizedBox(height: 50.0),

                  Padding(
                    padding: const EdgeInsets.only(left: 60.0, right: 60.0),
                    child: Column(
                      children: [
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
                                color: Colors.grey[300],
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
                                color: Colors.grey[300],
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
                                color: Colors.grey[300],
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
                                color: Colors.grey[300],
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
                        ],),
                  const SizedBox(height: 55.0),
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
                  const SizedBox(height: 35.0),
                  TextButton(
                      onPressed: (){
                        final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                        provider.logout();
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.logout, color: Colors.black),
                          const SizedBox(width: 5.0),
                          Text('Log Out', style: TextStyle(color: Colors.black),)
                      ],
                      ))


                ],),
              ),

            ],),
            ),
          ),
        ],
      ),
    );

  }
}