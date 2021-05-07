part of 'workout.dart';

class _WorkoutSession {
  final MethodChannel _channel;
  late List<WorkoutFeature> _features;

  _WorkoutSession(this._channel) {
    _channel.setMethodCallHandler(_handleMessage);
  }

  final StreamController<WorkoutReading> _streamController =
      StreamController<WorkoutReading>.broadcast();

  Stream<WorkoutReading> get _stream {
    return _streamController.stream;
  }

  Future<void> _start(List<WorkoutFeature> features) async {
    _features = features;

    final List<String> sensors = [];
    if (Platform.isAndroid) {
      if (features.contains(WorkoutFeature.heartRate)) {
        final PermissionStatus status = await Permission.sensors.request();
        if (status.isGranted) {
          sensors.add(EnumToString.convertToString(WorkoutFeature.heartRate));
        }
      }
      if (features.contains(WorkoutFeature.calories) ||
          features.contains(WorkoutFeature.steps)) {
        final PermissionStatus status =
            await Permission.activityRecognition.request();
        if (status.isGranted) {
          if (features.contains(WorkoutFeature.calories)) {
            sensors.add(EnumToString.convertToString(WorkoutFeature.calories));
          }
          if (features.contains(WorkoutFeature.steps)) {
            sensors.add(EnumToString.convertToString(WorkoutFeature.steps));
          }
        }
      }
      if (features.contains(WorkoutFeature.distance) ||
          features.contains(WorkoutFeature.speed)) {
        final PermissionStatus status = await Permission.location.request();
        if (status.isGranted) {
          if (features.contains(WorkoutFeature.distance)) {
            sensors.add(EnumToString.convertToString(WorkoutFeature.distance));
          }
          if (features.contains(WorkoutFeature.speed)) {
            sensors.add(EnumToString.convertToString(WorkoutFeature.speed));
          }
        }
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

  Future<void> _stop() async {
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

      _streamController.add(WorkoutReading._(feature, value));
      return Future.value();
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
