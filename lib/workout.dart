import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

part 'workout_reading.dart';

part 'workout_session.dart';

class Workout {
  static const MethodChannel _channel = const MethodChannel('workout');

  final _streamController = StreamController<WorkoutReading>.broadcast();
  final _session = WorkoutSession(_channel);

  Stream<WorkoutReading> get stream => _streamController.stream;

  Workout() {
    _session.stream.listen(
      (event) => _streamController.add(
        WorkoutReading(event.sensor, event.value),
      ),
    );
  }

  Future<void> start(List<WorkoutSensor> sensors) async {
    return _session.start(sensors);
  }

  Future<void> stop() {
    return _session.stop();
  }
}
