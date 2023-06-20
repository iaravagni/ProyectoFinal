// import 'package:flutter/material.dart';
// import 'bluetooth/BackgroundCollectingTask2.dart';
//
// class EMGProcessingWidget extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//     final BackgroundCollectingTask task = BackgroundCollectingTask.of(context, rebuildOnChange: true);
//
//     List<double> emgSignal = task.totalData; //from BackgroundCollectingTask2
//     List<int> contractionIntervals = [];
//
//     void processEMGSignal() {
//       // EMG signal preprocessing and contraction interval calculations
//       //Detecting contractions based on threshold crossing
//
//       // Set the threshold for contraction detection
//       double threshold = 0.5;
//
//       // Detect contractions based on threshold crossing
//       bool isContraction = false;
//       int contractionStartIndex = 0;
//
//       for (int i = 0; i < emgSignal.length; i++) {
//         if (emgSignal[i] > threshold) {
//           if (!isContraction) {
//             // Start of a new contraction
//             isContraction = true;
//             contractionStartIndex = i;
//           }
//         } else {
//           if (isContraction) {
//             // End of a contraction
//             isContraction = false;
//             int contractionDuration = i - contractionStartIndex;
//             contractionIntervals.add(contractionDuration);
//           }
//         }
//       }
//     }
//     // Preprocess EMG signal and calculate contraction intervals
//     processEMGSignal();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('EMG Processing'),
//       ),
//       body: Container(
//         // Widget UI here...
//       ),
//     );
//   }
// }