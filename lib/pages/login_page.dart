import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/pages/google_sign_in_page.dart';
import 'package:provider/provider.dart';

import 'loading_page.dart';
import 'navigation_page.dart';
import 'registration_page.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
      child: Container(
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            minimumSize: Size(300,50),
          ),
          icon: FaIcon(FontAwesomeIcons.google, color: Colors.red,),
          label: Text('Sign Up with Google account'),
          onPressed: (){
            final provider = Provider.of<GoogleSignInProvider>(context, listen: false);

            provider.googleLogin();
          },
        ),

      ),
    );
}


class Login extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.purple[100],
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          print('hola');
          print(newUser);
          //newUser = true;
          if (snapshot.connectionState == ConnectionState.waiting){
            //return Center(child: CircularProgressIndicator());
            return Center(child: Loading());
          } else if (snapshot.hasData && newUser) {
            return Registration1();
          } else if (snapshot.hasData){
            return Navigation();
          } else if (snapshot.hasError){
            return const Center(child: Text('Something went wrong!'),);
          } else {
            return SignUpWidget();
          }
        }
      )

  );
}