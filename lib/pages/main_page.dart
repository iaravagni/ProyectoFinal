import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/pages/google_sign_in_page.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'auth_page.dart';
import 'loading_page.dart';
import 'navigation_page.dart';
import 'registration_page.dart';
import 'signin_page.dart';

class MainPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Scaffold(
      body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting){
              return Center(child: Loading());
            } else if (snapshot.hasData) {
              return Navigation();
            } else if (snapshot.hasError){
              return const Center(child: Text('Something went wrong!'),);
            } else {
              return Auth();
            }
          }
      )

  );
}