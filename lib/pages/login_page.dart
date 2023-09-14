import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:myapp/pages/google_sign_in_page.dart';
import 'package:provider/provider.dart';

import 'loading_page.dart';
import 'navigation_page.dart';


bool response = false;

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
        // initialData: numUsers,
        builder: (context, snapshot) {
          print('hola');

          if (snapshot.connectionState == ConnectionState.waiting){
            //return Center(child: CircularProgressIndicator());
            print('Loading...');
            return Center(child: Loading());
          } else if (snapshot.hasData) {

            // print('tengo usuario');
            // final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
            // provider.googleLogin().then((value) {
            //   print('response 1');
            //   response=value;
            //   print(response);
            // });
            // print('response 2');
            // print(response);
            // if(response) {
            //     print('registration');
            //     return Registration1();
            // }else{
            print('navigation');
            return Navigation();
          } else if (snapshot.hasError){
            print('error');
            return const Center(child: Text('Something went wrong!'),);
          } else {
            print('signup');
            return SignUpWidget();
          }
        }
      )

  );
}