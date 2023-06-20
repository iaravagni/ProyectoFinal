import 'package:flutter/material.dart';
import 'package:myapp/Resources/user_info.dart';
import '../Resources/my_clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'edit_info_page.dart';
import 'navigation_page.dart';

//UserData actualUser = new UserData();

enum MenuItem{
  editInfo,
  logOut,
}

class Profile extends StatefulWidget{
  final Function(int) updateSelectedIndex; // Declare the callback function as a parameter

  const Profile(this.updateSelectedIndex, {super.key});

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
              padding: const EdgeInsets.only(top: 50.0),
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          PopupMenuButton(
                            icon: Icon(Icons.more_vert,color: Colors.white),
                            onSelected: (value){
                              if (value == MenuItem.editInfo){
                                Route route = MaterialPageRoute(builder: (context) => const EditInfo());
                                Navigator.push(context, route).then((res) => refreshPage());
                              } else if (value == MenuItem.logOut){
                                FirebaseAuth.instance.signOut();
                                actualUser.name = '';
                              }
                            },
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8.0),
                                bottomRight: Radius.circular(8.0),
                                topLeft: Radius.circular(8.0),
                                topRight: Radius.circular(8.0),
                              ),
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: MenuItem.editInfo,
                                  child: Row(
                                    children: const [
                                      Icon(Icons.edit),
                                      SizedBox(width: 10,),
                                      Text('Edit profile'),
                                    ],
                                  )
                              ),
                              PopupMenuItem(
                                value: MenuItem.logOut,
                                child: Row(
                                  children: const [
                                    Icon(Icons.logout),
                                    SizedBox(width: 10,),
                                    Text('Log out'),
                                  ],
                                ))
                            ]
                          ),
                        ],
                      ),

                      const SizedBox(height: 10.0),

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
                                widget.updateSelectedIndex(1);
                              },
                              child: const Text(
                                'Start recording',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18.0,
                                    letterSpacing: 1.0,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ),
                            // const SizedBox(height: 15.0),
                            // TextButton(
                            //     onPressed: () {
                            //       FirebaseAuth.instance.signOut();
                            //       actualUser.name = '';
                            //     },
                            //     child: Row(
                            //       mainAxisAlignment: MainAxisAlignment.center,
                            //       children: [
                            //         Icon(Icons.logout, color: Colors.black),
                            //         const SizedBox(width: 5.0),
                            //         Text('Log Out',
                            //           style: TextStyle(color: Colors.black),)
                            //       ],
                            //     ))


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
