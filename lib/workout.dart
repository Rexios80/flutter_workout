import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:health_tizen/health_tizen.dart';

class Workout {
  static const MethodChannel _channel = const MethodChannel('workout');

  final _streamController = StreamController<WorkoutReading>.broadcast();
  HealthTizen? _healthTizen;

  Stream<WorkoutReading> get stream => _streamController.stream;

  Future<void> start() {
    if (Platform.isAndroid) {
      return _startAndroid();
    } else {
      // Platform.isTizen
      return _startTizen();
    }
  }

  void stop() {
    if (Platform.isAndroid) {
      _stopAndroid();
    } else {
      // Platform.isTizen
      _stopTizen();
    }
  }

  Future<void> _startAndroid() {
    return Future.error(UnimplementedError());
  }

  Future<void> _startTizen() {
    _healthTizen = HealthTizen();

    _healthTizen?.stream.listen(
      (event) => _streamController.add(
        WorkoutReading(
          event.sensor == TizenSensor.hrm
              ? WorkoutReadingType.heartRate
              : WorkoutReadingType.unknown,
          event.value,
        ),
      ),
    );

    return _healthTizen?.start([TizenSensor.hrm]) ??
        Future.error("_healthTizen not initialized");
  }

  void _stopAndroid() {}

  void _stopTizen() {
    _healthTizen?.stop();
  }
}

class WorkoutReading {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final WorkoutReadingType type;
  final double value;

  WorkoutReading(this.type, this.value);
}

enum WorkoutReadingType {
  unknown,
  heartRate,
}
