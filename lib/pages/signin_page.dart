import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../Resources/text_form.dart';


class Login extends StatefulWidget {

  final VoidCallback showRegisterPage;
  const Login({Key? key, required this.showRegisterPage}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController(text: 'iaru@gmail.com');
  final _passwordController = TextEditingController(text: '12345678');

  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  void _validateInputs() {
    if (_formKey.currentState!.validate()) {
      signIn();
    } else {
      setState(() {
        _autoValidate = AutovalidateMode.always;
      });
    }
  }

  Future signIn() async{

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim()
      );
    }on FirebaseAuthException catch(e){
      String dialogText = '';
      if(e.code=='wrong-password') {
        dialogText = 'Incorrect password.';
      } else if (e.code == 'user-not-found') {
        dialogText = 'Email not registered. Please sign up.';
      }

      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Sign in error'),
            content: Text(dialogText),
            actions: [ TextButton(
                onPressed: (){Navigator.pop(context);},
                child: Text('OK'),
              style: TextButton.styleFrom(
                primary: Colors.deepPurple, // Text Color
              ),)],

          );
        });
    }
  }


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple[100],
      body:SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 45.0, right: 45.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Icon(Icons.pregnant_woman, size: 100,),
                  Image.asset(
                      'assets/logoVAIA_sinFondo.png',
                      height: 250,),
                  //SizedBox(height: 5,),
                  Text(
                    'Hello again!',
                    style: TextStyle(color: Colors.grey[800], fontSize: 45, fontWeight: FontWeight.bold,  letterSpacing: 2.0),),
                    // style: TextStyle(
                    //   fontWeight: FontWeight.bold,
                    //   fontSize: 36,
                  //    )
                  // ),

                  SizedBox(height: 10),
                  Text(
                  'Welcome back, you\'ve been missed!',
                  style: TextStyle(color: Colors.grey[800], fontSize: 16, letterSpacing: 2.0),),
                  // style: TextStyle(
                  //   fontSize: 20,
                  // ),
                  // ),

                  SizedBox(height: 50),

                  Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20.0))),

                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 40, 20, 40),
                      child: Column(children:[

                        Form(
                          key: _formKey,
                          child: FormUI(),
                          autovalidateMode: _autoValidate,
                        ),

                        SizedBox(height: 30,),

                        GestureDetector(
                          onTap: _validateInputs,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color(0xFF4c405c),
                              borderRadius: BorderRadius.circular((12)),
                            ),
                            child: Center(
                              child: Text(
                                'SIGN IN',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15.0,
                                  letterSpacing: 2.0,
                                  fontWeight: FontWeight.bold,
                                  // fontSize: 18,
                                ),
                              ),
                            ),
                          ),

                        ),


                      ],),
                    ),
                  ),

                  SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Not a member? ',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: widget.showRegisterPage,
                        child: Text(
                          'Register now',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              decorationThickness: 2,
                              color: Color(0xFF4c405c),
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      )
                    ],

                  )

                ],
              ),
            ),
          ),
        ),
      )

    );
  }

  Widget FormUI(){
    return Column(children: [

      ParameterWidget(_emailController, _emailValidator, 'EMAIL'),

      SizedBox(height: 20,),

      ParameterWidget(_passwordController, null, 'PASSWORD', obscure: true),


    ],);
  }

  String? _emailValidator(String? value) {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (value!.isEmpty) {
      return 'Cannot be empty';
    }
    if (!regex.hasMatch(value)) {
      return 'Enter Valid Email';
    } else {
      return null;
    }
  }

}
