import 'package:flutter/material.dart';

import 'registration_page.dart';
import 'signin_page.dart';

class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  State<Auth> createState() => _AuthState();
}

class _AuthState extends State<Auth> {

  bool showLoginPage = true;

  void toggleScreens() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage){
      return Login(showRegisterPage: toggleScreens);
    } else {
      return Registration(showLoginPage: toggleScreens);
    }
  }
}
