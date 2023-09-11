import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'PDF/mobile.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Report extends StatefulWidget{

  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {

  bool downloadButton = true;
  bool isGeneratingPDF = false; // Variable to track PDF generation state

  String patientName = 'Jane Doe';
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String patientAge = '30';
  String weeksPregnant = '25';
  String durationValue = '30 seconds';
  String frequencyValue = '5 minutes';
  String intensityValue = '5';
  String numContractions = '10';
  String measurementDuration = '20 seconds';

  // PDF generation function
  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();


    final page1 = document.pages.add();
    final font = PdfFontFamily.timesRoman;
    final Size pageSize = page1.getClientSize();

    //Patient info header
    PdfGrid gridPatient = PdfGrid();
    gridPatient.style = PdfGridStyle(
        font: PdfStandardFont(font,9),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2,bottom: 2)
    );

    gridPatient.columns.add(count: 2);

    PdfGridRow row = gridPatient.rows.add();
    row.cells[0].value = 'Patient: $patientName';
    row.cells[1].value = 'Age: $patientAge';

    row = gridPatient.rows.add();
    row.cells[0].value = 'Date: $date';
    row.cells[1].value = 'Weeks pregnant: $weeksPregnant';

    transparentBorders(gridPatient);

    // Title
    const String title = 'Pregnancy Contractions Report';
    final PdfFont fontTitle = PdfStandardFont(font, 14, style: PdfFontStyle.bold);

    final Size textSizeTitle = fontTitle.measureString(title);

    final double xTitle = (pageSize.width - textSizeTitle.width) / 2;
    final double yTitle = 130.0;

    // Subtitles
    const String subtitle1 = 'Contractions information';
    const String subtitle2 = 'Measurement information';

    final PdfFont fontSubtitle = PdfStandardFont(font, 12, style: PdfFontStyle.bold);

    //Contractions grid
    PdfGrid gridContractions = PdfGrid();
    gridContractions.style = PdfGridStyle(
        font: PdfStandardFont(font,10),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2,bottom: 2)
    );

    gridContractions.columns.add(count: 1);

    PdfGridRow rowC = gridContractions.rows.add();
    rowC.cells[0].value = 'Duration: $durationValue';

    rowC = gridContractions.rows.add();
    rowC.cells[0].value = 'Frequency: $frequencyValue';

    rowC = gridContractions.rows.add();
    rowC.cells[0].value = 'Intensity: $intensityValue';

    rowC = gridContractions.rows.add();
    rowC.cells[0].value = 'Number of contractions: $numContractions';

    transparentBorders(gridContractions);

    //Measurement grid
    PdfGrid gridMeasure = PdfGrid();
    gridMeasure.style = PdfGridStyle(
        font: PdfStandardFont(font,10),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2,bottom: 2)
    );

    gridMeasure.columns.add(count: 1);

    PdfGridRow rowM = gridMeasure.rows.add();
    rowM.cells[0].value = 'Recording duration: $measurementDuration';

    transparentBorders(gridMeasure);


    // PDF Layout

    //Header & footer
    for (int pageIndex = 1; pageIndex <= document.pages.count; pageIndex++) {

      //Header

      final PdfPage currentPage = document.pages[pageIndex - 1];

      currentPage.graphics.drawImage(
          PdfBitmap(await _readImageData('vaia_header.png')),
          Rect.fromLTWH(0, 0, pageSize.width, 60));

      gridPatient.draw(
          page: currentPage, bounds: const Rect.fromLTWH(10, 70, 0, 0)
      );

      currentPage.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0), width: 0.5), // Pen for the line (black color, 1-point width)
        Offset(0, 110), // Starting point (X, Y)
        Offset(pageSize.width, 110), // Ending point (X, Y)
      );

      // Footer
      final String footer = 'Page $pageIndex';
      final PdfFont fontFooter = PdfStandardFont(font, 9);

      final Size textSizeFooter = fontTitle.measureString(footer);

      final double xFooter = (pageSize.width - textSizeFooter.width) / 2;
      final double yFooter = currentPage.getClientSize().height - 36;


      currentPage.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0), width: 0.1), // Pen for the line (black color, 1-point width)
        Offset(0, yFooter+5), // Starting point (X, Y)
        Offset(xFooter - 5, yFooter+5), // Ending point (X, Y) (adjust the -5 as needed for spacing)
      );

      currentPage.graphics.drawString(footer, fontFooter, bounds: Rect.fromLTWH(xFooter, yFooter, 0,0));

      // Calculate the starting and ending points for the second line
      final double xSecondLineStart = xFooter + textSizeFooter.width -10; // Adjust the 5 for spacing
      final double xSecondLineEnd = pageSize.width;

      // Draw the second line starting just after the footer and ending at the right margin
      currentPage.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0), width: 0.1), // Pen for the second line (black color, 1-point width)
        Offset(xSecondLineStart, yFooter+5), // Starting point (X, Y)
        Offset(xSecondLineEnd, yFooter+5), // Ending point (X, Y)
      );


    }

    // Page 1

    page1.graphics.drawString(title, fontTitle, bounds: Rect.fromLTWH(xTitle, yTitle, textSizeTitle.width, textSizeTitle.height));

    page1.graphics.drawString(subtitle1, fontSubtitle, bounds: Rect.fromLTWH(10, 160, 0, 0));

    gridContractions.draw(
        page: page1, bounds: const Rect.fromLTWH(10, 180, 0, 0)
    );

    page1.graphics.drawString(subtitle2, fontSubtitle, bounds: Rect.fromLTWH(10, 280, 0, 0));

    gridMeasure.draw(
        page: page1, bounds: const Rect.fromLTWH(10, 300, 0, 0)
    );

    page1.graphics.drawImage(
        PdfBitmap(await _readImageData('emg_signal.png')),
        Rect.fromLTWH(0, 320, pageSize.width, 110));

    List<int> bytes = await document.save();
    document.dispose();

    saveAndLaunchFile(bytes, 'VAIA Report.pdf');

  }

  Future<Uint8List> _readImageData(String name) async {
    final data = await rootBundle.load('assets/report/figures/$name');
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  PdfGrid transparentBorders(grid) {
    for (int i = 0; i < grid.rows.count; i++) {
      for (int j = 0; j < grid.columns.count; j++) {
        grid.rows[i].cells[j].style.borders.all = PdfPens.transparent;
      }
    }

    return grid;
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
                          // child: ElevatedButton(
                          //   style: ElevatedButton.styleFrom(
                          //       backgroundColor: Colors.purple[100],
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(100),
                          //       )),
                          //   child: Icon(Icons.download_rounded, size: 40.0),
                          //   onPressed: (downloadButton == true) ? () {
                          //     _createPDF(); // Call the _createPDF function
                          //   } : null,
                          // ),),

                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purple[100],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                            child: isGeneratingPDF
                                ? SpinKitFadingCircle(color: Colors.white)// Display a loading indicator while generating
                                : Icon(Icons.download_rounded, size: 40.0),
                            onPressed: (downloadButton == true && !isGeneratingPDF) ? () async {
                              setState(() {
                                isGeneratingPDF = true;
                              });

                              // Introduce a slight delay to allow the UI to update
                              await Future.delayed(Duration(milliseconds: 900)); // Adjust the duration as needed

                              await _createPDF(); // Wait for PDF generation to complete

                              setState(() {
                                isGeneratingPDF = false;
                              });
                            } : null,
                          )),

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