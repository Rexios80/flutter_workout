part of 'workout.dart';

class _WorkoutSession {
  final MethodChannel _channel;

  _WorkoutSession(this._channel) {
    _channel.setMethodCallHandler(_handleMessage);
  }

  final StreamController<WorkoutReading> _streamController =
      StreamController<WorkoutReading>.broadcast();

  Stream<WorkoutReading> get _stream {
    return _streamController.stream;
  }

  Future<void> _start(List<WorkoutSensor> sensors) async {
    final PermissionStatus status = await Permission.sensors.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      return Future<void>.error('Health permissions not granted');
    }
    return _channel.invokeMethod<void>(
        'start', sensors.map(EnumToString.convertToString).toList());
  }

  Future<void> _stop() async {
    return _channel.invokeMethod<void>('stop');
  }

  Future<dynamic> _handleMessage(MethodCall call) {
    try {
      final List<dynamic> arguments = call.arguments as List<dynamic>;
      final sensorString = arguments[0] as String;
      final values = arguments.sublist(1).map((e) => e as double).toList();

      final sensor =
          EnumToString.fromString(WorkoutSensor.values, sensorString) ??
              WorkoutSensor.unknown;

      final Map<WorkoutFeature, double> features = Map();
      switch (sensor) {
        case WorkoutSensor.unknown:
          // Ignore these
          return Future.value();
        case WorkoutSensor.heartRate:
          features[WorkoutFeature.heartRate] = values[0];
          break;
        case WorkoutSensor.pedometer:
          features[WorkoutFeature.steps] = values[0];
          features[WorkoutFeature.distance] = values[1];
          features[WorkoutFeature.calories] = values[2];
          features[WorkoutFeature.speed] = values[3];
          break;
      }

      features.entries
          .map((e) => WorkoutReading._(sensor, e.key, e.value))
          .forEach((e) => _streamController.add(e));
      return Future.value();
    } catch (e) {
      print(e);
      return Future.error(e);
    }
  }
}
