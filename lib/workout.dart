import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:health_tizen/health_tizen.dart';

class Workout {
  static const MethodChannel _channel = const MethodChannel('workout');

  final _streamController = StreamController<WorkoutReading>.broadcast();

  Stream<WorkoutReading> get stream => _streamController.stream;

  Future<void> start() {
    if (Platform.isAndroid) {
      return _startAndroid();
    } else {
      // Platform.isTizen
      return _startTizen();
    }
  }

  Future<void> _startAndroid() {
    return Future.error(UnimplementedError());
  }

  Future<void> _startTizen() {
    final health = HealthTizen();

    health.stream.listen(
      (event) => _streamController.add(
        WorkoutReading(
          event.sensor == TizenSensor.hrm
              ? WorkoutReadingType.heartRate
              : WorkoutReadingType.unknown,
          event.value,
        ),
      ),
    );

    return health.start([TizenSensor.hrm]);
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
