import 'dart:async';
import 'package:flutter/services.dart';
import 'package:workout/src/workout_session.dart';

import 'package:workout/workout.dart';

/// Base class for flutter_workout
class Workout {
  static const MethodChannel _channel = MethodChannel('workout');

  final _streamController = StreamController<WorkoutReading>.broadcast();
  final _session = WorkoutSession(_channel);

  /// A stream of [WorkoutReading] collected by the workout session.
  Stream<WorkoutReading> get stream => _streamController.stream;

  /// Create a [Workout]
  Workout() {
    _session.stream.listen(
      (event) => _streamController.add(
        WorkoutReading(event.feature, event.value),
      ),
    );
  }

  /// Starts a workout session with the specified [features] enabled.
  ///
  /// Returns [Future.error] if starting the session fails.
  Future<void> start(List<WorkoutFeature> features) async {
    return _session.start(features);
  }

  /// Stops the workout session and sensor data collection.
  ///
  /// Returns [Future.error] if stopping the session fails.
  Future<void> stop() {
    return _session.stop();
  }
}
