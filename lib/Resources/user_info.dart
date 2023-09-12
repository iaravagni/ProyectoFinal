import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class UserData {
  late String uid = '';
  late String name = '';
  late String surname = '';
  late String age = '';
  late String weeks = '';
  late String prevPreg = '';
  late String numChildren = '';
  late String pregRisk = '';
  late String reports = '';
}

class ReportItem {
  final String pdfName;

  ReportItem(this.pdfName);
}


Future<UserData> userInfo() async {

  UserData actualUser = new UserData();

  final userUID = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final docRef = _firestore.collection("users").doc(userUID);

  await docRef.get().then(
        (DocumentSnapshot doc) {

      final user = doc.data() as Map<String, dynamic>;

      actualUser.uid = userUID;
      actualUser.name = user['name'];
      actualUser.surname = user['surname'];
      actualUser.age = user['age'];
      actualUser.weeks = user['weeks'];
      actualUser.prevPreg = user['prevPreg'];
      actualUser.numChildren = user['numChildren'];
      actualUser.pregRisk = user['pregRisk'];
      actualUser.reports = user['reports'];
    }
  );

  return actualUser;
}

Future<List<String>> getReportName(String userUID) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  try {
    final QuerySnapshot querySnapshot = await firestore
        .collection('reports')
        .where('userUID', isEqualTo: userUID)
        .get();

    final List<String> reportItems = querySnapshot.docs
        .map((doc) => doc['pdfIdentifier'] as String)
        .toList();

    return reportItems;
  } catch (e) {
    print('Error fetching user reports: $e');
    return []; // Handle the error as needed
  }
}
