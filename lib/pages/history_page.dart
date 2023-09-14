import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import the SpinKit library

import 'PDF/mobile.dart';
import 'navigation_page.dart';

class History extends StatefulWidget {
  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<bool> isGeneratingPDFList = List.generate(actualUser.reportsName.length, (index) => false);
  List<bool> isDeletingPDFList = List.generate(actualUser.reportsName.length, (index) => false);

  Future showPDF(currentReport, index) async {
    final pdfFileName = '$currentReport VAIA report.pdf';
    final pdfFileRef = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('reports')
        .child(pdfFileName);

    final pdfData = await pdfFileRef.getData(1024 * 1024);

    saveAndLaunchFile(Uint8List.fromList(pdfData as List<int>), pdfFileName);

    setState(() {
      isGeneratingPDFList[index] = false; // Set the loading state to false after PDF is generated
    });
  }

  Future<void> deletePDF(currentReport, index) async {
    try {
      final pdfFileName = '$currentReport VAIA report.pdf';
      final pdfFileRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('reports')
          .child(pdfFileName);

      // Set the loading state to true for the delete button
      setState(() {
        isDeletingPDFList[index] = true;
      });

      await pdfFileRef.delete(); // Delete the PDF file from Firebase Storage

      // Delete the PDF metadata from Firestore
      final FirebaseFirestore firestore = FirebaseFirestore.instance;
      await firestore.collection('reports').doc(currentReport).delete();

      // Remove the item from reportItems
      setState(() {
        actualUser.reportsName.removeAt(index);
      });

      // Update the user's reports count by subtracting 1
      await decreaseReportsNum();

      print('PDF deleted: $pdfFileName');
    } catch (e) {
      print('Error deleting PDF: $e');
      // Handle the error as needed
    } finally {
      // Set the loading state to false after the operation is complete
      setState(() {
        isDeletingPDFList[index] = false;
      });
    }
  }

  Future<void> decreaseReportsNum() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;


    String reportsNum = (int.parse(actualUser.reports) - 1).toString();


    actualUser.reports = reportsNum;

    await _firestore.collection('users').doc(actualUser.uid).update(
      {
        'reports': reportsNum,
      },
    );
  }


  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  color: Colors.purple[100],
                  child: const Column(
                    children: [
                      SizedBox(height: 55.0),
                      Center(
                        child: Icon(
                          Icons.history_rounded,
                          color: Colors.white70,
                          size: 50.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Center(
                        child: Text(
                          'History',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2.0,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),

                Expanded(
                  child: ListView.builder(
                    itemCount: actualUser.reportsName.length,
                    itemBuilder: (context, index) {
                      final currentReportName = actualUser.reportsName[index];
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              currentReportName,
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  letterSpacing: 2.0,
                                  fontSize: 16.0
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // IconButton(
                                //   icon: Icon(Icons.delete_rounded, color: Colors.grey[600]),
                                //   onPressed: () async {
                                //     deletePDF(currentReportName, index);
                                //   },
                                // ),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent, // Set background color to transparent
                                    elevation: 0, // Remove shadow
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      side: BorderSide(color: Colors.transparent), // Add a border to make it visible
                                    ),
                                  ),
                                  child: isDeletingPDFList[index]
                                      ? SpinKitFadingCircle(color: Colors.grey[600], size: 20,) // Change color to black while loading
                                      : Icon(Icons.delete_rounded, color: Colors.grey[600]),
                                  onPressed: () {
                                    // Implement delete functionality
                                    deletePDF(currentReportName, index);
                                  },
                                ),

                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: Colors.transparent, // Set background color to transparent
                                    elevation: 0, // Remove shadow
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100),
                                      side: BorderSide(color: Colors.transparent), // Add a border to make it visible
                                    ),
                                  ),
                                  child: isGeneratingPDFList[index]
                                      ? SpinKitFadingCircle(color: Colors.grey[600], size: 20,) // Change color to black while loading
                                      : Icon(Icons.download_rounded, color: Colors.grey[600]),
                                  onPressed: () async {
                                    if (!isGeneratingPDFList[index]) {
                                      setState(() {
                                        isGeneratingPDFList[index] = true; // Set loading state to true
                                      });

                                      await showPDF(currentReportName, index);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Divider(), // Add a divider between items
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
