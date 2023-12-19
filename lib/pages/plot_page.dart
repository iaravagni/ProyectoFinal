import 'package:flutter/material.dart';
import 'package:myapp/pages/bluetooth/BackgroundCollectingTask2.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'dart:async';

class Plot extends StatefulWidget {
  Plot({Key? key, required this.plotButton}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final bool plotButton;

  @override
  _PlotState createState() => _PlotState();
}

class _PlotState extends State<Plot> {
  late List<LiveData> chartData;
  late ChartSeriesController _chartSeriesController;
  int lastTime = 0; // Index to keep track of data in totalData

  @override
  // void initState() {
  //   if (widget.plotButton) {
  //     chartData = getChartData();
  //     Timer.periodic(const Duration(milliseconds: 20), updateDataSource);
  //     super.initState();
  //   } else {
  //     chartData = [];
  //     super.initState();
  //   }
  //
  //
  // }

  void initState() {
    if (widget.plotButton) {
      chartData = getInitialChartData();
      Timer.periodic(const Duration(milliseconds: 20), updateDataSource);
      super.initState();
    } else {
      chartData = [];
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            Container(
              color: Colors.purple[100],
              child: const Column(
                children: [
                  SizedBox(height: 55.0),
                  Center(
                    child: Icon(
                      Icons.auto_graph_rounded,
                      color: Colors.white70,
                      size: 50.0,
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Center(
                    child: Text(
                      'Plot',
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

            const SizedBox(height: 50.0),

            SfCartesianChart(
                series: <LineSeries<LiveData, int>>[
                  LineSeries<LiveData, int>(
                    onRendererCreated: (ChartSeriesController controller) {
                      _chartSeriesController = controller;
                    },
                    dataSource: chartData,
                    color: const Color.fromRGBO(76, 64, 92, 1),
                    xValueMapper: (LiveData sales, _) => sales.time,
                    yValueMapper: (LiveData sales, _) => sales.sample,
                  )
                ],
                primaryXAxis: NumericAxis(
                    majorGridLines: const MajorGridLines(width: 0),
                    edgeLabelPlacement: EdgeLabelPlacement.shift,
                    interval: 200,
                    title: AxisTitle(text: 'Time (seconds)')),
                primaryYAxis: NumericAxis(
                    axisLine: const AxisLine(width: 0),
                    majorTickLines: const MajorTickLines(size: 0),
                    title: AxisTitle(text: 'Voltage (mV)'),
                    minimum: 0, // Set the minimum value of the y-axis
                    maximum: 5, // Set the maximum value of the y-axis
            )),
          ],
        ));
  }

  // void updateDataSource(Timer timer) {
  //   chartData.add(LiveData(time++, (math.Random().nextInt(60) + 30)));
  //   chartData.removeAt(0);
  //   _chartSeriesController.updateDataSource(
  //       addedDataIndex: chartData.length - 1, removedDataIndex: 0);
  // }



  void updateDataSource(Timer timer) {
    if (totalData.length >= 400) {
      // Get the last 400 items from totalData
      List<double> last400Items = totalData.sublist(
        totalData.length - 400,
        totalData.length,
      );

      // Update chartData with the last 400 items
      chartData = last400Items.map((item) => LiveData(lastTime++, item)).toList();

      print('ChartData:');
      // print(chartData[].sample);

      _chartSeriesController.updateDataSource(
        addedDataIndex: chartData.length - 1,
        removedDataIndex: 0,
      );
    }
  }

  List<LiveData> getInitialChartData() {
    List<LiveData> plotData = [];
    int startIndex = totalData.length >= 400 ? totalData.length - 400 : 0;
    for (int i = startIndex; i < totalData.length; i++) {
      plotData.add(LiveData(lastTime++, totalData[i]));
    }
    return plotData;
  }

}




  // void updateDataSource(Timer timer) {
  //   // Generate a new LiveData object using the next value from getChartData
  //   //chartData = [];
  //   LiveData newData = getChartData().removeAt(0);
  //
  //   // Remove the oldest data point from chartData
  //   chartData.removeAt(0);
  //
  //   // Add the new data point to chartData
  //   chartData.add(newData);
  //
  //   print(chartData);
  //
  //   // Update the chart with the new data
  //   _chartSeriesController.updateDataSource(
  //     addedDataIndex: chartData.length - 1,
  //     removedDataIndex: 0,
  //   );
  // }
  //
  // List<LiveData> getChartData() {
  //   List<LiveData> plotData = [];
  //   List<double> croppedData = [];
  //
  //   int cantItems = 400;
  //   int totalItems = totalData.length;
  //
  //   if (totalItems >= cantItems) {
  //     int startIndex = totalItems - cantItems;
  //     int endTime = totalItems;
  //
  //     // Update croppedData with the last 400 items
  //     croppedData = totalData.sublist(startIndex, endTime);
  //
  //     // Generate LiveData objects with time values
  //     for (int i = 0; i < cantItems; i++) {
  //       plotData.add(LiveData(i, croppedData[i]));
  //     }
  //   } else {
  //     // If there are fewer than 400 items, generate LiveData objects with time values from 0 to totalItems
  //     croppedData = totalData;
  //
  //     for (int i = 0; i < totalItems; i++) {
  //       plotData.add(LiveData(i, croppedData[i]));
  //     }
  //   }
  //
  //   return plotData;
  // }
  //


// int lastTime = 0;
  // List<LiveData> getChartData() {
  //   List<LiveData> plotData = [];
  //   List<double> croppedData = [];
  //
  //   int cantItems = 400;
  //   //int lastTime = 0; // Initialize lastTime
  //
  //   croppedData = totalData.sublist(
  //     totalData.length >= cantItems ? totalData.length - cantItems : 0,
  //     totalData.length,
  //   );
  //
  //   // Generate LiveData objects with time values
  //   for (int i = 0; i < croppedData.length; i++) {
  //     plotData.add(LiveData(lastTime++, croppedData[i]));
  //   }
  //
  //   return plotData;
  // }


class LiveData {
  LiveData(this.time, this.sample);
  final int time;
  final num sample;
}






// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'bluetooth/BackgroundCollectingTask2.dart'; // Import your data file here
//
// class LineChartWidget extends StatefulWidget {
//   LineChartWidget({Key? key}) : super(key: key);
//
//   @override
//   _LineChartWidgetState createState() => _LineChartWidgetState();
// }
//
// class _LineChartWidgetState extends State<LineChartWidget> {
//   //List<double> totalData = []; // Your total data
//   List<FlSpot> croppedData = []; // Cropped data to plot
//   int dataLength = 300; // Number of data points to plot initially
//   Timer? timer;
//
//   @override
//   void initState() {
//     super.initState();
//     // Initialize totalData with your data (replace this with your actual data)
//     //totalData = [/* Your actual data here */];
//
//     // Crop the data to the desired length
//     updateCroppedData();
//
//     startUpdateLoop();
//   }
//
//   void startUpdateLoop() {
//     // Update more frequently (adjust the duration as needed)
//     const updateInterval = Duration(milliseconds: 1);
//
//     Timer.periodic(updateInterval, (timer) {
//       updateCroppedData();
//     });
//   }
//
//   void updateCroppedData() {
//     // Crop the data to the desired length
//     // if (totalData.length <= dataLength) {
//     //   croppedData = List.generate(totalData.length, (index) => FlSpot(index.toDouble(), totalData[index]));
//     // } else {
//     //   croppedData = List.generate(dataLength, (index) => FlSpot(index.toDouble(), totalData[index]));
//     // }
//
//     //croppedData = [];
//
//     // Calculate the start index to take the last dataLength values
//     int startIndex = totalData.length - dataLength;
//     if (startIndex < 0) {
//       startIndex = 0;
//     }
//
//     // Take the last dataLength values from totalData
//     if (totalData.length <= dataLength) {
//         croppedData = List.generate(totalData.length, (index) => FlSpot(index.toDouble(), totalData[startIndex + index]));
//       } else {
//         croppedData = List.generate(dataLength, (index) => FlSpot(index.toDouble(), totalData[startIndex + index]));
//     }
//
//
//     // Increment the data length for the next update
//     //dataLength += 10;
//
//     // Re-render the page
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     // Cancel the timer when the widget is disposed
//     timer?.cancel();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       body: Stack(
//         children: [
//           Container(
//             child: Column(
//               children: [
//                 Container(
//                   color: Colors.purple[100],
//                   child: const Column(
//                     children: [
//                       SizedBox(height: 55.0),
//                       Center(
//                         child: Icon(
//                           Icons.auto_graph_rounded,
//                           color: Colors.white70,
//                           size: 50.0,
//                         ),
//                       ),
//                       SizedBox(height: 10.0),
//                       Center(
//                         child: Text(
//                           'Plot',
//                           style: TextStyle(
//                             color: Colors.white,
//                             letterSpacing: 2.0,
//                             fontSize: 30.0,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20.0),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 50.0),
//
//                 AspectRatio(
//                   aspectRatio: 2,
//                   child: LineChart(
//                     LineChartData(
//                       lineBarsData: [
//                         LineChartBarData(
//                           spots: croppedData,
//                           isCurved: false,
//                           color: Color(0xFF4c405c),
//                           dotData: FlDotData(show: false),
//                         ),
//                       ],
//                       gridData: const FlGridData(
//                         show: false,
//                       ),
//                       titlesData: const FlTitlesData(
//                         leftTitles: AxisTitles(
//                           sideTitles: SideTitles(showTitles: true),
//                         ),
//                         rightTitles: AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                         bottomTitles: AxisTitles(
//                           sideTitles: SideTitles(showTitles: true),
//                         ),
//                         topTitles: AxisTitles(
//                           sideTitles: SideTitles(showTitles: false),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
