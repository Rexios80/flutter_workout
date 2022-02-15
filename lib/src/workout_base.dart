import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:workout/workout.dart';

/// Base class for flutter_workout
class Workout {
  static const _channel = MethodChannel('workout');

  final _streamController = StreamController<WorkoutReading>.broadcast();

  var _currentFeatures = <WorkoutFeature>[];

  /// A stream of [WorkoutReading] collected by the workout session
  Stream<WorkoutReading> get stream => _streamController.stream;

  /// Create a [Workout]
  Workout() {
    _channel.setMethodCallHandler(_handleMessage);
  }

  /// Starts a workout session with the specified [features] enabled
  Future<void> start(List<WorkoutFeature> features) async {
    _currentFeatures = features;
    final List<String> sensors;
    if (Platform.isAndroid) {
      sensors = await _initWearOS();
    } else {
      // This is Tizen
      sensors = await _initTizen();
    }
    return _channel.invokeMethod<void>('start', {'sensors': sensors});
  }

  Future<List<String>> _initWearOS() async {
    // TODO: Request necessary permissions based on what features are used
    await Permission.sensors.request();
    await Permission.activityRecognition.request();
    await Permission.location.request();
    return _currentFeatures.map((e) => e.name).toList();
  }

  Future<List<String>> _initTizen() async {
    final sensors = <String>[];
    final status = await Permission.sensors.request();
    if (status.isGranted) {
      if (_currentFeatures.contains(WorkoutFeature.heartRate)) {
        sensors.add(WorkoutFeature.heartRate.name);
      }
      if (_currentFeatures.contains(WorkoutFeature.calories) ||
          _currentFeatures.contains(WorkoutFeature.steps) ||
          _currentFeatures.contains(WorkoutFeature.distance) ||
          _currentFeatures.contains(WorkoutFeature.speed)) {
        sensors.add('pedometer');
      }
    }
    return sensors;
  }

  /// Stops the workout session and sensor data collection
  Future<void> stop() {
    return _channel.invokeMethod<void>('stop');
  }

  Future<dynamic> _handleMessage(MethodCall call) {
    try {
      final arguments = call.arguments as List<dynamic>;
      final featureString = arguments[0] as String;
      final value = arguments[1] as double;

      if (!_currentFeatures.map((e) => e.name).contains(featureString)) {
        // Don't send features the developer didn't ask for (ahem... Tizen)
        return Future.value();
      }

      final feature = WorkoutFeature.values.byName(featureString);

      _streamController.add(WorkoutReading(feature, value));
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }
}
