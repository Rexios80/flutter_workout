import 'dart:async';
import 'dart:io' show Platform;

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

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
        // Not sure why not making this shorthand makes the analyzer happier
        WorkoutReading._(event.feature, event.value),
      ),
    );
  }

  /// Starts a workout session with the specified [features] enabled.
  ///
  /// Returns [Future.error] if starting the session fails.
  Future<void> start(List<WorkoutFeature> features) async {
    return _session._start(features);
  }

  /// Stops the workout session and sensor data collection.
  ///
  /// Returns [Future.error] if stopping the session fails.
  Future<void> stop() {
    return _session._stop();
  }
}
