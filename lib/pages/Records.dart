import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './read%20data/get_user_name.dart';

class Records extends StatefulWidget {
  const Records({Key? key}) : super(key: key);

  @override
  State<Records> createState() => _RecordsState();
}

class _RecordsState extends State<Records> {

  //final _db = FirebaseFirestore.instance;
  List<String> docIDs = [];

  Future getDocID() async{
    await FirebaseFirestore.instance.collection('Resultados').get().then((value) =>
    value.docs.forEach((element) {
      print(element.reference);
      docIDs.add(element.reference.id);
    }));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Records')
      ),
      body:Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: FutureBuilder(
                future: getDocID(),
                builder: (context, value){
                return ListView.builder(
                    itemCount: docIDs.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            tileColor: Colors.grey[200],
                            title: GetUserName(documentId: docIDs[index]),
                      ),);
                    });
              },),
              )
            ],
        ),
      )
    );
  }
}
