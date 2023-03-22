import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GetUserName extends StatelessWidget {
 //const GetUserName({Key? key}) : super(key: key);

  final String documentId;
  GetUserName({required this.documentId});

  @override
  Widget build(BuildContext context) {

    CollectionReference resultados = FirebaseFirestore.instance.collection("Resultados");

    return FutureBuilder<DocumentSnapshot>(
      future: resultados.doc(documentId).get(),
      builder: ((context, value) {
      if (value.connectionState == ConnectionState.done){
        Map<String, dynamic> data = value.data!.data() as Map<String, dynamic>;
        return Text(
                'Heart Rate: ${data['FC']}' + '\n'
                'Breathing Rate: ${data['FR']}' + '\n'
                'SpO2: ${data['SpO2']}' + '\n'
                'Sleep Duration [min]: ${data['Duracion']}' + '\n'
                'Light Sleep [min]: ${data['LS']}' + '\n'
                'Deep Sleep [min]: ${data['DS']}' + '\n'
                'Awake [min]: ${data['AW']}' + '\n'
                'PVC: ${data['PVC']}' + '\n'
                'AF: ${data['AF']}' + '\n'
                'Tachycardia: ${data['Taquicardia']}' + '\n'
                'Bradycardia: ${data['Bradicardia']}' + '\n'
        );
      }
      return Text('loading..');
    }),
    );
  }
}
