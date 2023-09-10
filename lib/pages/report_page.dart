import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'PDF/mobile.dart';

class Report extends StatefulWidget{

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {

  bool downloadButton = true;

  String patientName = 'John Doe';
  String date = '2023-08-25';
  String patientAge = '30';
  String weeksPregnant = '25';
  String durationValue = '30 seconds';
  String frequencyValue = '5 minutes';
  String intensityValue = 'High';
  String numContractions = '10';
  String measurementDuration = '20 seconds';

  // PDF generation function
  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();
    final page = document.pages.add();

    const String title = 'Pregnancy Contractions Report';
    final PdfFont font = PdfStandardFont(PdfFontFamily.helvetica, 14);

    final Size pageSize = page.getClientSize();
    final Size textSize = font.measureString(title);

    final double x = (pageSize.width - textSize.width) / 2;
    final double y = 50.0; // Adjust the Y-coordinate as needed
    
    page.graphics.drawImage(
        PdfBitmap(await _readImageData('vaia_header.png')),
        Rect.fromLTWH(0,100, 440, 550));

    page.graphics.drawString(title, font, bounds: Rect.fromLTWH(x, y, textSize.width, textSize.height));


    List<int> bytes = await document.save();
    document.dispose();

    saveAndLaunchFile(bytes, 'VAIA Report.pdf');

  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('assets/report/figures/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      body:  Stack(
        children: [
          Container(
              child: Column(
                children: [
                  Container(
                    color: Colors.purple[100],
                    child: Column(
                        children: const [
                          SizedBox(height: 55.0),
                          Center(
                            child: Icon(
                              Icons.receipt_long_rounded,
                              color: Colors.white70,
                              size: 50.0,),
                          ),


                      SizedBox(height: 10.0),

                      Center(
                        child: Text(
                          'Last Report',
                          style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2.0,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                      ),

                      SizedBox(height: 20.0),
                      ],),),

                const SizedBox(height: 70.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(60.0,0.0,60.0,0.0),
                  child: Column( children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'NUMBER OF',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                          Text(
                            'DURATION OF',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                        ],
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CONTRACTIONS',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                          Text(
                            'CONTRACTIONS',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 120.0,
                            width: 140.0,
                            decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: const BorderRadius.all(Radius.circular(20.0))),
                            child: Center(
                              child: Text(
                                '-', //TODO: Change to variable user.pregnancies
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    letterSpacing: 2.0,
                                    fontSize: 50.0
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 120.0,
                            width: 140.0,
                            decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: const BorderRadius.all(Radius.circular(20.0))),
                            child: Center(
                              child: Text(
                                '-', //TODO: Change to variable user.children
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    letterSpacing: 2.0,
                                    fontSize: 50.0
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'TIME BETWEEN',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                          Text(
                            'CONTRACTIONS',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'CONTRACTIONS',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                          Text(
                            'INTENSITY',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 12.0
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 15.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            height: 120.0,
                            width: 140.0,
                            decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: const BorderRadius.all(Radius.circular(20.0))),
                            child: Center(
                              child: Text(
                                '-', //TODO: Change to variable user.risk
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    letterSpacing: 2.0,
                                    fontSize: 50.0
                                ),
                              ),
                            ),
                          ),
                          Container(
                            height: 120.0,
                            width: 140.0,
                            decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: const BorderRadius.all(Radius.circular(20.0))),
                            child: Center(
                              child: Text(
                                '-', //TODO: Change to variable user.reports
                                style: TextStyle(
                                    color: Colors.grey[900],
                                    letterSpacing: 2.0,
                                    fontSize: 50.0
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 60.0),

                      // Center(
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //         backgroundColor: Colors.purple[100],
                      //         shape: RoundedRectangleBorder(
                      //           borderRadius: BorderRadius.circular(100),
                      //         )),
                      //     child: Icon(Icons.download, size: 40.0),
                      //     onPressed: (downloadButton == true) ? () async {
                      //       //await saveCSVFile(totalData, painLevel);
                      //       initState();
                      //     } : null,
                      //   ),
                      // ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 100,
                          width: 100,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple[100],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                )),
                            child: Icon(Icons.download_rounded, size: 40.0),
                            onPressed: (downloadButton == true) ? () {
                              _createPDF(); // Call the _createPDF function
                            } : null,
                          ),),

                        const SizedBox(height: 10.0),

                        Text('DOWNLOAD',
                          style: TextStyle(
                              color: Colors.grey[700],
                              letterSpacing: 2.0,
                              fontSize: 15.0),),
                        Text('REPORT',
                          style: TextStyle(
                              color: Colors.grey[700],
                              letterSpacing: 2.0,
                              fontSize: 15.0),),
                      ],),


                    ],
                  ),
              ),

            ],),
          ),],
      ),
    );

  }
}