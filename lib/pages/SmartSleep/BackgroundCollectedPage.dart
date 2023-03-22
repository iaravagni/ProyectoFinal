import 'package:flutter/material.dart';
import '../bluetooth/BackgroundCollectingTask.dart';

import '../helpers/LineChart.dart';
import '../helpers/PaintStyle.dart';
import 'SideMenuBar.dart';

class BackgroundCollectedPage extends StatelessWidget {

  //final bool checkAvailability2;


  @override
  Widget build(BuildContext context) {
    final BackgroundCollectingTask task =
    BackgroundCollectingTask.of(context, rebuildOnChange: true);

    // Arguments shift is needed for timestamps as miliseconds in double could loose precision.
    final int argumentsShift =
        task.samples.first.timestamp.millisecondsSinceEpoch;

    final Duration showDuration = Duration(hours: 2); // @TODO . show duration should be configurable

    final Iterable<DataSample> lastSamples = task.getLastOf(showDuration);

    final Iterable<double> arguments = lastSamples.map((sample) {
      return (sample.timestamp.millisecondsSinceEpoch - argumentsShift)
          .toDouble();
    });

    // Step for argument labels
    final Duration argumentsStep =
    Duration(minutes: 15); // @TODO . step duration should be configurable

    // Find first timestamp floored to step before
    final DateTime beginningArguments = lastSamples.first.timestamp;
    DateTime beginningArgumentsStep = DateTime(beginningArguments.year,
        beginningArguments.month, beginningArguments.day);
    while (beginningArgumentsStep.isBefore(beginningArguments)) {
      beginningArgumentsStep = beginningArgumentsStep.add(argumentsStep);
    }
    beginningArgumentsStep = beginningArgumentsStep.subtract(argumentsStep);
    final DateTime endingArguments = lastSamples.last.timestamp;

    // Generate list of timestamps of labels
    final Iterable<DateTime> argumentsLabelsTimestamps = () sync* {
      DateTime timestamp = beginningArgumentsStep;
      yield timestamp;
      while (timestamp.isBefore(endingArguments)) {
        timestamp = timestamp.add(argumentsStep);
        yield timestamp;
      }
    }();

    // Map strings for labels
    final Iterable<LabelEntry> argumentsLabels =
    argumentsLabelsTimestamps.map((timestamp) {
      return LabelEntry(
          (timestamp.millisecondsSinceEpoch - argumentsShift).toDouble(),
          ((timestamp.hour <= 9 ? '0' : '') +
              timestamp.hour.toString() +
              ':' +
              (timestamp.minute <= 9 ? '0' : '') +
              timestamp.minute.toString()));
    });


    return Scaffold(
        appBar: AppBar(
          title: Text('Collected data'),
          actions: <Widget>[
            // Progress circle
            (task.inProgress
                ? FittedBox(
                child: Container(
                    margin: new EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.white))))
                : Container(/* Dummy */)),
            // Start/stop buttons
            (task.inProgress
                ? IconButton(icon: Icon(Icons.pause), onPressed: task.pause)
                : IconButton(
                icon: Icon(Icons.play_arrow), onPressed: task.resume)),
          ],
        ),
        drawer: const NavigatorDrawer(),

        body: ListView(
          children: <Widget>[
            Divider(),
            ListTile(
              leading: const Icon(Icons.brightness_7),
              title: const Text('Accelerometer'),
            ),
            LineChart(
              constraints: const BoxConstraints.expand(height: 275),
              arguments: arguments,
              argumentsLabels: argumentsLabels,
              values: [
                lastSamples.map((sample) => sample.eje_x),
                lastSamples.map((sample) => sample.eje_y),
                lastSamples.map((sample) => sample.eje_z),
              ],
              verticalLinesStyle: const PaintStyle(color: Colors.grey),
              additionalMinimalHorizontalLabelsInterval: 0,
              additionalMinimalVerticalLablesInterval: 0,
              seriesPointsStyles: [
                null,
                null,
                null,
                /*const PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 1.7*3,
                    color: Colors.indigo,
                    strokeCap: StrokeCap.round),*/
              ],
              seriesLinesStyles: [
                const PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 1.7,
                    color: Colors.indigoAccent),
                const PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 1.7,
                    color: Colors.redAccent),
                const PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 1.7,
                    color: Colors.blueAccent),
              ],
            ),
            Divider(),
            ListTile(
              leading: const Icon(Icons.filter_vintage),
              title: const Text('PPG Signal'),
            ),
            LineChart(
              constraints: const BoxConstraints.expand(height: 240),
              arguments: arguments,
              argumentsLabels: argumentsLabels,
              values: [
                lastSamples.map((sample) => sample.red),
              ],
              verticalLinesStyle: const PaintStyle(color: Colors.grey),
              additionalMinimalHorizontalLabelsInterval: 0,
              additionalMinimalVerticalLablesInterval: 0,
              seriesPointsStyles: [
                null,
              ],
              seriesLinesStyles: [
                const PaintStyle(
                    style: PaintingStyle.stroke,
                    strokeWidth: 1.7,
                    color: Colors.purpleAccent),
              ],
            ),

          ],
        ));
  }
}

  /*
    void onData(dynamic str) { setState(() { data = str; }); }


    @override
    Widget build(BuildContext context) {

      //Color color = ledState ? Colors.deepPurpleAccent : Colors.white24;
      TextTheme theme = Theme.of(context).textTheme;

    return Scaffold(
        appBar: AppBar(title: Text('Collected data')),
        body: Container(
          decoration: BoxDecoration(color: Colors.white),
          child: Center(
           child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Sensor Value', style: theme.displayMedium.copyWith(color: Colors.white)),
              Text(task.samples, style: theme.displayMedium.copyWith(color: Colors.white)),
            ],
        )

        ),
    ),*/












