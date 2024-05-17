import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:workout/workout.dart';
import 'package:flutter_tizen/flutter_tizen.dart' as tizen;

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

  /// Wear OS: The supported [ExerciseType]s of the device
  ///
  /// Tizen: Always empty
  ///
  /// iOS: Always empty
  Future<List<ExerciseType>> getSupportedExerciseTypes() async {
    if (!Platform.isAndroid) return [];

    final result =
        await _channel.invokeListMethod<int>('getSupportedExerciseTypes');

    final types = <ExerciseType>[];
    for (final id in result!) {
      final type = ExerciseType.fromId(id);
      if (type == null) {
        debugPrint(
          'Unknown ExerciseType id: $id. Please create an issue for this on GitHub.',
        );
      } else {
        types.add(type);
      }
    }

    return types;
  }

  /// Starts a workout session with the specified [features] enabled
  ///
  /// [exerciseType] has no effect on Tizen
  ///
  /// [enableGps] allows location information to be used to estimate
  /// distance/speed instead of steps. Will request location permission.
  /// Only available on Wear OS.
  ///
  /// [locationType], [swimmingLocationType], and [lapLength] are iOS only
  ///
  /// [lapLength] is the length of the pool in meters
  ///
  /// iOS: Calls `startWatchApp` with the given configuration. The `workout`
  /// plugin cannot read data from an Apple Watch. See the `watch_connectivity`
  /// plugin for watch communication.
  Future<WorkoutStartResult> start({
    required ExerciseType exerciseType,
    required List<WorkoutFeature> features,
    bool enableGps = false,
    WorkoutLocationType? locationType,
    WorkoutSwimmingLocationType? swimmingLocationType,
    double? lapLength,
  }) {
    _currentFeatures = features;

    if (Platform.isAndroid) {
      return _initWearOS(exerciseType: exerciseType, enableGps: enableGps);
    } else if (Platform.isIOS) {
      return _initIos(
        exerciseType: exerciseType,
        locationType: locationType,
        swimmingLocationType: swimmingLocationType,
        lapLength: lapLength,
      );
    } else if (tizen.isTizen) {
      // This is Tizen
      return _initTizen();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  Future<WorkoutStartResult> _initWearOS({
    required ExerciseType exerciseType,
    required bool enableGps,
  }) async {
    final sensors = <String>[];

    if (_currentFeatures.contains(WorkoutFeature.heartRate)) {
      final status = await Permission.sensors.request();
      if (status.isGranted) {
        sensors.add(WorkoutFeature.heartRate.name);
      }
    }

    final activityRecognitionFeatures = {
      WorkoutFeature.calories,
      WorkoutFeature.steps,
      WorkoutFeature.distance,
      WorkoutFeature.speed,
    };
    final requestedActivityRecognitionFeatures =
        _currentFeatures.toSet().intersection(activityRecognitionFeatures);

    if (requestedActivityRecognitionFeatures.isNotEmpty) {
      final status = await Permission.activityRecognition.request();
      if (status.isGranted) {
        sensors.addAll(requestedActivityRecognitionFeatures.map((e) => e.name));
      }
    }

    if (enableGps) {
      final status = await Permission.location.request();
      if (!status.isGranted) {
        enableGps = false;
      }
    }

    return _start(
      exerciseType: exerciseType,
      sensors: sensors,
      enableGps: enableGps,
    );
  }

  Future<WorkoutStartResult> _initIos({
    required ExerciseType exerciseType,
    required WorkoutLocationType? locationType,
    required WorkoutSwimmingLocationType? swimmingLocationType,
    required double? lapLength,
  }) {
    return _start(
      exerciseType: exerciseType,
      locationType: locationType,
      swimmingLocationType: swimmingLocationType,
      lapLength: lapLength,
    );
  }

  Future<WorkoutStartResult> _initTizen() async {
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
    return _start(sensors: sensors);
  }

  Future<WorkoutStartResult> _start({
    ExerciseType? exerciseType,
    List<String> sensors = const [],
    bool enableGps = false,
    WorkoutLocationType? locationType,
    WorkoutSwimmingLocationType? swimmingLocationType,
    double? lapLength,
  }) async {
    final result = await _channel.invokeMapMethod<String, dynamic>(
      'start',
      {
        'exerciseType': exerciseType?.id,
        'sensors': sensors,
        'enableGps': enableGps,
        'locationType': locationType?.id,
        'swimmingLocationType': swimmingLocationType?.id,
        'lapLength': lapLength,
      },
    );
    return WorkoutStartResult.fromResult(result);
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

      // I can't get maps to work in C++ and there aren't any errors, so this is what we got
      late final int? timestamp;
      try {
        timestamp = arguments[2] as int;
      } catch (_) {
        timestamp = null;
      }

      if (!_currentFeatures.map((e) => e.name).contains(featureString)) {
        // Don't send features the developer didn't ask for (ahem... Tizen)
        return Future.value();
      }

      final feature = WorkoutFeature.values.byName(featureString);

      _streamController.add(WorkoutReading(feature, value, timestamp));
      return Future.value();
    } catch (e) {
      return Future.error(e);
    }
  }
}
