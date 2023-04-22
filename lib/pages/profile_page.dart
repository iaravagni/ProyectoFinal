import 'package:flutter/material.dart';
import 'package:myapp/Resources/user_info.dart';
import '../Resources/my_clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'loading_page.dart';
import 'edit_info_page.dart';
import 'navigation_page.dart';

//UserData actualUser = new UserData();

class Profile extends StatefulWidget{
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        extendBodyBehindAppBar: true,

        body: Stack(
          children: [
            ClipPath(
                clipper: MyClipper(),
                child: Container(
                  color: Colors.purple[100],
                )
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // CircleAvatar(
                            //   radius: 30,
                            //   backgroundImage: NetworkImage(user.photoURL!),
                            // ),

                            Text(
                              actualUser.name + ' ',
                              style: const TextStyle(
                                color: Colors.white, //Colors.grey[900],
                                letterSpacing: 2.0,
                                fontSize: 45.0,
                                //fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              (actualUser.surname).toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white, //Colors.grey[900],
                                letterSpacing: 2.0,
                                fontSize: 45.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),


                      const SizedBox(height: 15.0),

                      Center(
                        child: Text(
                          '${actualUser.weeks} weeks pregnant',
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2.0,
                              fontSize: 20.0
                          ),
                        ),
                      ),


                      const SizedBox(height: 110.0),

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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0))),
                                  child: Center(
                                    child: Text(
                                      actualUser.prevPreg,
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0))),
                                  child: Center(
                                    child: Text(
                                      actualUser.numChildren,
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0))),
                                  child: Center(
                                    child: Text(
                                      actualUser.pregRisk,
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
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(20.0))),
                                  child: Center(
                                    child: Text(
                                      actualUser.reports,
                                      style: TextStyle(
                                          color: Colors.grey[900],
                                          letterSpacing: 2.0,
                                          fontSize: 50.0
                                      ),
                                    ),
                                  ),
                                ),
                              ],),
                            const SizedBox(height: 65.0),

                            TextButton(
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(20)),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0))
                                ),
                                backgroundColor: const MaterialStatePropertyAll(
                                  Color(0xFF4c405c)),
                              ),
                              onPressed: () {
                                Route route = MaterialPageRoute(builder: (context) => const EditInfo());
                                Navigator.push(context, route).then((res) => refreshPage());
                              },
                              child: const Text(
                                '     Edit information     ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            const SizedBox(height: 15.0),
                            TextButton(
                                onPressed: () {
                                  FirebaseAuth.instance.signOut();
                                  actualUser.name = '';
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.logout, color: Colors.black),
                                    const SizedBox(width: 5.0),
                                    Text('Log Out',
                                      style: TextStyle(color: Colors.black),)
                                  ],
                                ))


                          ],),
                      ),

                    ],),
                ),
              ),
            ),
          ],
        ),
      );
   }
}
