part of 'workout.dart';

class WorkoutSession {
  final MethodChannel _channel;

  WorkoutSession(this._channel) {
    _channel.setMethodCallHandler(_handleMessage);
  }

  final StreamController<WorkoutReading> _streamController =
      StreamController<WorkoutReading>.broadcast();

  Stream<WorkoutReading> get stream {
    return _streamController.stream;
  }

  Future<void> start(List<WorkoutSensor> sensors) async {
    final PermissionStatus status = await Permission.sensors.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      return Future<void>.error('Health permissions not granted');
    }
    return _channel.invokeMethod<void>(
        'start', sensors.map(EnumToString.convertToString).toList());
  }

  Future<void> stop() async {
    return _channel.invokeMethod<void>('stop');
  }

  Future<dynamic> _handleMessage(MethodCall call) {
    try {
      final List<dynamic> arguments = call.arguments as List<dynamic>;

      _streamController.add(
        WorkoutReading(
          EnumToString.fromString(WorkoutSensor.values, arguments[0]) ??
              WorkoutSensor.unknown,
          arguments[1],
        ),
      );
      return Future<void>.value();
    } catch (e) {
      print(e);
      return Future<void>.error(e);
    }
  }
}
