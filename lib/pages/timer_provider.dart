import 'dart:async';
import 'package:flutter/foundation.dart';

class TimerProvider extends ValueNotifier<Duration> {
  late Timer _timer;
  Stopwatch _stopwatch = Stopwatch();
  bool _isRunning = false;

  TimerProvider() : super(Duration.zero);

  bool get isRunning => _isRunning;

  void start() {
    if (!_isRunning) {
      reset();
      _isRunning = true;
      _stopwatch.start();
      _timer = Timer.periodic(Duration(milliseconds: 10), (_) {
        value = _stopwatch.elapsed;
      });
    }
  }

  void stop() {
    if (_isRunning) {
      _isRunning = false;
      _stopwatch.stop();
      _timer.cancel();
    }
  }

  String formatTime() {
    final milliseconds = _stopwatch.elapsedMilliseconds;
    final seconds = (milliseconds / 1000).floor();
    final minutes = (seconds / 60).floor();
    final hours = (minutes / 60).floor();

    final formattedHours = hours.toString().padLeft(2, '0');
    final formattedMinutes = (minutes % 60).toString().padLeft(2, '0');
    final formattedSeconds = (seconds % 60).toString().padLeft(2, '0');
    final formattedMilliseconds = ((milliseconds % 1000) ~/ 10).toString().padLeft(2, '0');

    return '$formattedHours:$formattedMinutes:$formattedSeconds.$formattedMilliseconds';
  }

  void reset() {
    if (!_isRunning) {
      _stopwatch.reset();
      value = Duration.zero;
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}

