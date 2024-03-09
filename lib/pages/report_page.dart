import 'package:flutter/material.dart';
import 'package:myapp/pages/bluetooth/BackgroundCollectingTask2.dart';
import 'package:myapp/pages/record_page.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'PDF/mobile.dart';
import 'package:intl/intl.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'timer_provider.dart';
import 'navigation_page.dart';
import 'signal_processing.dart';

bool downloadButton = false;

class Report extends StatefulWidget {
  @override
  State<Report> createState() => _ReportState();
}

class _ReportState extends State<Report> {
  late ReportParam report;


  bool isGeneratingPDF = false; // Variable to track PDF generation state

  String patientName = '${actualUser.name} ${actualUser.surname}';
  String date = DateFormat('yyyy-MM-dd').format(DateTime.now());
  String patientAge = actualUser.age;
  String weeksPregnant = actualUser.weeks;
  String durationValue = '10';
  String frequencyValue = '2';
  String intensityValue = '0.55';
  String numContractions = '3';
  String measurementDuration = '20 seconds'; //todo: Actualizar

  String lastUpdate = '-';

  bool shouldAttendHealthcareCenter = false; // Variable booleana para indicar si se debe asistir al centro de salud o quedarse en casa


  // Método asincrónico para procesar la señal
  Future<void> _processSignal(List<double> totalData, Duration duration) async {
    // Esperar el resultado de SignalProcessing
    report = await SignalProcessing(totalData, duration);

    // Llamar setState para reconstruir el widget con la nueva información
    setState(() {
      durationValue = '${report.duration}';
      numContractions = '${report.number}';
      // frequencyValue = '${report.frequency}';
      frequencyValue = '${report.last10}';
      intensityValue = '${report.intensity.toStringAsFixed(2)}';
    });
  }

  Future updateReportsNum() async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    String reportsNum = (int.parse(actualUser.reports) + 1).toString();

    actualUser.reports = reportsNum;

    await _firestore.collection('users').doc(actualUser.uid).update({
      'reports': reportsNum,
    });
  }

  void updateReportItems(value) {
    actualUser.reportsName.add(value);
  }

  // PDF generation function
  Future<void> _createPDF() async {
    PdfDocument document = PdfDocument();

    final page1 = document.pages.add();
    const font = PdfFontFamily.timesRoman;
    final Size pageSize = page1.getClientSize();

    //Patient info header
    PdfGrid gridPatient = PdfGrid();
    gridPatient.style = PdfGridStyle(
        font: PdfStandardFont(font, 9),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

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
    final PdfFont fontTitle =
        PdfStandardFont(font, 14, style: PdfFontStyle.bold);

    final Size textSizeTitle = fontTitle.measureString(title);

    final double xTitle = (pageSize.width - textSizeTitle.width) / 2;
    const double yTitle = 130.0;

    // Subtitles
    const String subtitle1 = 'Contractions information';
    const String subtitle2 = 'Measurement information';

    final PdfFont fontSubtitle =
        PdfStandardFont(font, 12, style: PdfFontStyle.bold);

    //Contractions grid
    PdfGrid gridContractions = PdfGrid();
    gridContractions.style = PdfGridStyle(
        font: PdfStandardFont(font, 10),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

    gridContractions.columns.add(count: 1);

    PdfGridRow rowC = gridContractions.rows.add();
    rowC.cells[0].value = 'Duration: $durationValue' 'seconds';

    rowC = gridContractions.rows.add();
    rowC.cells[0].value =
        'Number of contractions in the last 10 minutes: $frequencyValue';

    rowC = gridContractions.rows.add();
    rowC.cells[0].value = 'Intensity: $intensityValue mV';

    rowC = gridContractions.rows.add();
    rowC.cells[0].value = 'Total number of contractions: $numContractions';

    transparentBorders(gridContractions);

    //Measurement grid
    PdfGrid gridMeasure = PdfGrid();
    gridMeasure.style = PdfGridStyle(
        font: PdfStandardFont(font, 10),
        cellPadding: PdfPaddings(left: 5, right: 2, top: 2, bottom: 2));

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
          page: currentPage, bounds: const Rect.fromLTWH(10, 70, 0, 0));

      currentPage.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0),
            width: 0.5), // Pen for the line (black color, 1-point width)
        const Offset(0, 110), // Starting point (X, Y)
        Offset(pageSize.width, 110), // Ending point (X, Y)
      );

      // Footer
      final String footer = 'Page $pageIndex';
      final PdfFont fontFooter = PdfStandardFont(font, 9);

      final Size textSizeFooter = fontTitle.measureString(footer);

      final double xFooter = (pageSize.width - textSizeFooter.width) / 2;
      final double yFooter = currentPage.getClientSize().height - 36;

      currentPage.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0),
            width: 0.1), // Pen for the line (black color, 1-point width)
        Offset(0, yFooter + 5), // Starting point (X, Y)
        Offset(
            xFooter - 5,
            yFooter +
                5), // Ending point (X, Y) (adjust the -5 as needed for spacing)
      );

      currentPage.graphics.drawString(footer, fontFooter,
          bounds: Rect.fromLTWH(xFooter, yFooter, 0, 0));

      // Calculate the starting and ending points for the second line
      final double xSecondLineStart =
          xFooter + textSizeFooter.width - 10; // Adjust the 5 for spacing
      final double xSecondLineEnd = pageSize.width;

      // Draw the second line starting just after the footer and ending at the right margin
      currentPage.graphics.drawLine(
        PdfPen(PdfColor(0, 0, 0),
            width: 0.1), // Pen for the second line (black color, 1-point width)
        Offset(xSecondLineStart, yFooter + 5), // Starting point (X, Y)
        Offset(xSecondLineEnd, yFooter + 5), // Ending point (X, Y)
      );
    }

    // Page 1

    page1.graphics.drawString(title, fontTitle,
        bounds: Rect.fromLTWH(
            xTitle, yTitle, textSizeTitle.width, textSizeTitle.height));

    page1.graphics.drawString(subtitle1, fontSubtitle,
        bounds: Rect.fromLTWH(10, 160, 0, 0));

    gridContractions.draw(
        page: page1, bounds: const Rect.fromLTWH(10, 180, 0, 0));

    page1.graphics.drawString(subtitle2, fontSubtitle,
        bounds: Rect.fromLTWH(10, 280, 0, 0));

    gridMeasure.draw(page: page1, bounds: const Rect.fromLTWH(10, 300, 0, 0));

    page1.graphics.drawImage(PdfBitmap(await _readImageData('emg_signal.png')),
        Rect.fromLTWH(0, 320, pageSize.width, 110));

    List<int> bytes = await document.save();
    document.dispose();

    // Generate a unique PDF identifier based on the timestamp
    final pdfIdentifier =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());

    // Generate a unique PDF file name
    final pdfFileName = '$pdfIdentifier VAIA report.pdf';

    // Upload the PDF to Firebase Storage
    await uploadPdfToFirebaseStorage(Uint8List.fromList(bytes), pdfFileName);

    // Store PDF metadata in Firestore
    await storePdfMetadata(pdfIdentifier);

    updateReportItems(pdfIdentifier);

    saveAndLaunchFile(bytes, pdfFileName);
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

  Future<void> uploadPdfToFirebaseStorage(
      Uint8List pdfBytes, String pdfFileID) async {
    try {
      final firebase_storage.Reference storageRef = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child(
              'reports') // Replace 'your-storage-folder' with your desired folder in Firebase Storage
          .child(pdfFileID);

      await storageRef.putData(pdfBytes);

      print('PDF uploaded to Firebase Storage: $pdfFileID');
    } catch (e) {
      print('Error uploading PDF to Firebase Storage: $e');
      // Handle the error as needed
    }
  }

  Future<void> storePdfMetadata(String pdfIdentifier) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    try {
      final String userUID = actualUser.uid;
      final String pdfFileName = '$pdfIdentifier.pdf';

      // Store metadata about the PDF in the "reports" collection
      await firestore.collection('reports').doc(pdfIdentifier).set({
        'userUID': userUID,
        'pdfIdentifier': pdfIdentifier,
        'fileName': pdfFileName,
        // Add other metadata as needed
      });

      print('PDF metadata stored in Firestore: $pdfIdentifier');
    } catch (e) {
      print('Error storing PDF metadata in Firestore: $e');
      // Handle the error as needed
    }
  }

  @override
  void initState() {
    super.initState();

    // Accede al TimerProvider usando Provider
    final timerProvider = Provider.of<TimerProvider>(context, listen: false);
    bool _hasProcessed = false; // Variable para rastrear si ya has procesado el intervalo de  10 segundos
    int lastSecond = 0;

    // Escucha los cambios en el temporizador
    timerProvider.addListener(() {
      final Duration duration = timerProvider.value;

      if (mounted) {
        if (duration.inSeconds >= 120 &&
            !_hasProcessed) { //para la primera vez que abris la tab
          _processSignal(totalData, duration);
          _hasProcessed = true;
          lastUpdate = DateFormat('hh:mm a').format(DateTime.now());
          lastSecond = duration.inSeconds;
              print(
              'INICIO REPORTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT!!!!!-----------------------------');
        }

        if (duration.inSeconds % 120 == 0 && lastSecond != duration.inSeconds &&
            _hasProcessed) { //ya adentro de la tab que actualice el valor
          _processSignal(totalData, duration);
          lastSecond = duration.inSeconds;
          lastUpdate = DateFormat('hh:mm a').format(DateTime.now());
          print(
              'NUEVOOOOOOOOOO REPORTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT!!!!!-----------------------------');
          print(duration.inSeconds);
          print(lastSecond != duration.inSeconds);
          print(_hasProcessed);
        }
      }
    });
  }

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
                  child: Column(
                    children: const [
                      SizedBox(height: 55.0),
                      Center(
                        child: Icon(
                          Icons.receipt_long_rounded,
                          color: Colors.white70,
                          size: 50.0,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Center(
                        child: Text(
                          'Last Report',
                          style: TextStyle(
                              color: Colors.white,
                              letterSpacing: 2.0,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 20.0),
                    ],
                  ),
                ),
                const SizedBox(height: 50.0),
                Padding(
                  padding: const EdgeInsets.fromLTRB(45.0, 0.0, 45.0, 0.0),
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text(
                            'NUMBER OF CONTRACTIONS',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 14.0),
                          ),
                          Text(
                            'IN THE LAST 10 MINUTES',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 14.0),
                          ),

                          const SizedBox(height: 10.0),

                          Container(
                            height: 84.0,
                            width: 500.0,
                            decoration: BoxDecoration(
                                color: Colors.grey[350],
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0))),
                            child: Center(
                              child: Text(
                                frequencyValue,
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    letterSpacing: 2.0,
                                    fontSize: 50.0),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20.0),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                'TOTAL',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    letterSpacing: 2.0,
                                    fontSize: 11.0),
                              ),
                              Text(
                                'CONTRACTIONS',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    letterSpacing: 2.0,
                                    fontSize: 10.0),
                              ),

                              const SizedBox(height: 5.0),

                              Container(
                                height: 84.0,
                                width: 98.0,
                                decoration: BoxDecoration(
                                    color: Colors.grey[350],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Center(
                                  child: Text(
                                    numContractions,
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        letterSpacing: 2.0,
                                        fontSize: 40.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'AVERAGE',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    letterSpacing: 2.0,
                                    fontSize: 11.0),
                              ),
                              Text(
                                'INTENSITY (mA)',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    letterSpacing: 2.0,
                                    fontSize: 10.0),
                              ),

                              const SizedBox(height: 5.0),

                              Container(
                                height: 84.0,
                                width: 98.0,
                                decoration: BoxDecoration(
                                    color: Colors.grey[350],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Center(
                                  child: Text(
                                    intensityValue,
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        letterSpacing: 2.0,
                                        fontSize: 40.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                'AVERAGE',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    letterSpacing: 2.0,
                                    fontSize: 11.0),
                              ),
                              Text(
                                'DURATION (s)',
                                style: TextStyle(
                                    color: Colors.grey[700],
                                    letterSpacing: 2.0,
                                    fontSize: 10.0),
                              ),

                              const SizedBox(height: 5.0),

                              Container(
                                height: 84.0,
                                width: 98.0,
                                decoration: BoxDecoration(
                                    color: Colors.grey[350],
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(20.0))),
                                child: Center(
                                  child: Text(
                                    durationValue,
                                    style: TextStyle(
                                        color: Colors.grey[800],
                                        letterSpacing: 2.0,
                                        fontSize: 40.0),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),


                      const SizedBox(height: 10.0),


                      Text(
                        'Last update: $lastUpdate',
                        style: TextStyle(
                            color: Colors.grey[700],
                            letterSpacing: 1.5,
                            fontStyle: FontStyle.italic,
                            fontSize: 12.0),
                      ),


                      const SizedBox(height: 35.0),



                      Container(
                      width: double.infinity, // Asegura que el contenedor ocupe todo el ancho
                        height: 1.5,
                        color: shouldAttendHealthcareCenter ? Color(0xFF4A2574) : Color(0xFFc8df59), // Cambia el color según el valor de la variable booleana
                      ),

                      const SizedBox(height: 20.0),

                      Text(
                        'Suggestion:',
                        style: TextStyle(
                          color: shouldAttendHealthcareCenter ? Color(0xFF4A2574) : Color(0xFFc8df59), // Cambia el color según el valor de la variable booleana
                          letterSpacing: 1.5,
                          fontStyle: FontStyle.italic,
                          fontSize: 12.0,
                        ),
                      ),

                      Text(
                        shouldAttendHealthcareCenter ? 'ATTEND HEALTHCARE CENTER' : 'STAY AT HOME', // Cambia el texto según el valor de la variable booleana
                        style: TextStyle(
                          color: shouldAttendHealthcareCenter ? Color(0xFF4A2574) : Color(0xFFc8df59), // Cambia el color según el valor de la variable booleana
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                          fontSize: 20.0,
                        ),
                      ),

                      const SizedBox(height: 20.0),

                      Container(
                        width: double.infinity, // Asegura que el contenedor ocupe todo el ancho
                        height: 1.5,
                        color: shouldAttendHealthcareCenter ? Color(0xFF4A2574) : Color(0xFFc8df59), // Cambia el color según el valor de la variable booleana
                      ),



          //
                      //
                      //
                      // Container(
                      //   width: double.infinity, // Ensure the container takes the full width
                      //   height: 1.5,
                      //   color: Color(0xFF4A2574), // Set the color of the the line
                      // ),
                      //
                      // const SizedBox(height: 20.0),
                      //
                      // Text(
                      //   'Suggestion:',
                      //   style: TextStyle(
                      //       color: Color(0xFF4A2574), // Set the color of the the line
                      //       letterSpacing: 1.5,
                      //       fontStyle: FontStyle.italic,
                      //       fontSize: 12.0),
                      // ),
                      //
                      // Text(
                      //   'ATTEND HEALTHCARE CENTER',
                      //   style: TextStyle(
                      //       // color: Colors.deepPurpleAccent[900], // Set the color of the line
                      //       color: Color(0xFF4A2574), // Set the color of the the line
                      //       fontWeight: FontWeight.bold,
                      //       letterSpacing: 1.5,
                      //       fontSize: 20.0),
                      // ),
                      //
                      // const SizedBox(height: 20.0),
                      //
                      //
                      // Container(
                      //   width: double.infinity, // Ensure the container takes the full width
                      //   height: 1.5,
                      //   color: Color(0xFF4A2574), // Set the color of the the line// Adjust the height of the line
                      // ),



                      const SizedBox(height: 35.0),


                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                              height: 80,
                              width: 80,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.purple[100],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(80),
                                  ),
                                ),
                                child: isGeneratingPDF
                                    ? SpinKitFadingCircle(
                                        color: Colors.white, size: 30) // Display a loading indicator while generating
                                    // : Icon(Icons.download_rounded,
                                    //     color: Colors.white, size: 40.0),
                                : Icon(Icons.download_rounded, size: 30.0, color: downloadButton ? Colors.white : null),
                                onPressed:
                                    (downloadButton == true && !isGeneratingPDF)
                                        ? () async {
                                            setState(() {
                                              isGeneratingPDF = true;
                                            });

                                            await updateReportsNum();

                                            // Introduce a slight delay to allow the UI to update
                                            //await Future.delayed(Duration(milliseconds: 900)); // Adjust the duration as needed

                                            await _createPDF(); // Wait for PDF generation to complete

                                            setState(() {
                                              isGeneratingPDF = false;
                                            });
                                          }
                                        : null,
                              )),
                          const SizedBox(height: 10.0),


                          Text(
                            'DOWNLOAD',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 13.0),
                          ),
                          Text(
                            'REPORT',
                            style: TextStyle(
                                color: Colors.grey[700],
                                letterSpacing: 2.0,
                                fontSize: 13.0),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  @override
  bool get wantKeepAlive => true;
}
// }
