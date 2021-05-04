part of 'workout.dart';

class WorkoutReading {
  final timestamp = DateTime.now().millisecondsSinceEpoch;
  final WorkoutSensor sensor;
  final double value;

  WorkoutReading(this.sensor, this.value);
}

enum WorkoutSensor {
  unknown,
  heartRate,
}
