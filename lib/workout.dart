import 'dart:async';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io' show Platform;

part 'workout_reading.dart';

part 'workout_session.dart';

class Workout {
  static const MethodChannel _channel = const MethodChannel('workout');

  final _streamController = StreamController<WorkoutReading>.broadcast();
  final _session = _WorkoutSession(_channel);

  /// A stream of [WorkoutReading] collected by the workout session.
  Stream<WorkoutReading> get stream => _streamController.stream;

  Workout() {
    _session._stream.listen(
      (event) => _streamController.add(
        WorkoutReading._(event.sensor, event.values),
      ),
    );
  }

  /// Starts a workout session with the specified [sensors] enabled.
  ///
  /// Returns [Future.error] if starting the session fails.
  Future<void> start(List<WorkoutSensor> sensors) async {
    return _session._start(sensors);
  }

  /// Stops the workout session and sensor data collection.
  ///
  /// Returns [Future.error] if stopping the session fails.
  Future<void> stop() {
    return _session._stop();
  }
}
