import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class UserData {
  late String name = '';
  late String surname = '';
  late String age = '';
  late String weeks = '';
  late String prevPreg = '';
  late String numChildren = '';
  late String pregRisk = '';
  late String reports = '0';
}

Future<UserData> userInfo()async{

  UserData actualUser = new UserData();

  final userUID = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final docRef = _firestore.collection("users").doc(userUID);

  await docRef.get().then(
        (DocumentSnapshot doc) {

      final user = doc.data() as Map<String, dynamic>;

      actualUser.name = user['name'];
      actualUser.surname = user['surname'];
      actualUser.age = user['age'];
      actualUser.weeks = user['weeks'];
      actualUser.prevPreg = user['prevPreg'];
      actualUser.numChildren = user['numChildren'];
      actualUser.pregRisk = user['pregRisk'];

      print(user['name']);
      print(actualUser.pregRisk);
      //return actualUser;
    }
  );

  return actualUser;
}