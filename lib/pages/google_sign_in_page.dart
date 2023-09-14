import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';


bool newUser = false;

Future<bool> getDoc(user) async{
  var a = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
  var output = false;
  if(a.exists){
    print('Exists');
    output = true;
  } else if(!a.exists){
    print('Not exists');
    output = false;
  }
  return output;
}

class GoogleSignInProvider extends ChangeNotifier{
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool result = false;

  Future googleLogin()async {
    try {
      final googleUSer = await googleSignIn.signIn();
      if (googleUSer == null ) return;
      _user = googleUSer;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;
      final googleAuth = await googleUSer.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;



      if (user != null){
        newUser = !await getDoc(user);
        //corrioGoogle = true;
        print('pag google');
        print(newUser);
        if (newUser) {
          result = true;

          await _firestore.collection('users').doc(user.uid).set(
              {
                'username': user.displayName,
                'uid': user.uid,
                'profilePhoto': user.photoURL,

              }
          );
        }
      }
      print('corrio google');
      //print(corrioGoogle);
      return result;
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }


  Future logout() async {
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}


