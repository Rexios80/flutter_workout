import 'dart:async';
import 'dart:io';

import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workout/workout.dart';

/// An internal wrapper for the workout session
class WorkoutSession {
  final MethodChannel _channel;
  late List<WorkoutFeature> _features;

  /// Create a [WorkoutSession]
  WorkoutSession(this._channel) {
    _channel.setMethodCallHandler(_handleMessage);
  }

  final StreamController<WorkoutReading> _streamController =
      StreamController<WorkoutReading>.broadcast();

  /// The stream of [WorkoutReading]s
  Stream<WorkoutReading> get stream {
    return _streamController.stream;
  }

  /// Start the workout session
  Future<void> start(List<WorkoutFeature> features) async {
    _features = features;

    final List<String> sensors = [];
    if (Platform.isAndroid) {
      for (var e in features) {
        sensors.add(EnumToString.convertToString(e));
      }
    } else {
      // This is Tizen
      final PermissionStatus status = await Permission.sensors.request();
      if (status.isGranted) {
        if (features.contains(WorkoutFeature.heartRate)) {
          sensors.add(EnumToString.convertToString(WorkoutFeature.heartRate));
        }
        if (features.contains(WorkoutFeature.calories) ||
            features.contains(WorkoutFeature.steps) ||
            features.contains(WorkoutFeature.distance) ||
            features.contains(WorkoutFeature.speed)) {
          sensors.add('pedometer'); // Why? Ask Tizen.
        }
      }
    }
    return _channel.invokeMethod<void>('start', sensors);
  }

  /// Stop the workout session
  Future<void> stop() async {
    return _channel.invokeMethod<void>('stop');
  }

  Future<dynamic> _handleMessage(MethodCall call) {
    try {
      final List<dynamic> arguments = call.arguments as List<dynamic>;
      final featureString = arguments[0] as String;
      final value = arguments[1] as double;

      if (!_features
          .map(EnumToString.convertToString)
          .contains(featureString)) {
        // Don't send features the developer didn't ask for (ahem... Tizen)
        return Future.value();
      }

      final feature =
          EnumToString.fromString(WorkoutFeature.values, featureString) ??
              WorkoutFeature.unknown;

      _streamController.add(WorkoutReading(feature, value));
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }
}
