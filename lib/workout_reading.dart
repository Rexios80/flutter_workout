part of 'workout.dart';

class WorkoutReading {
  /// The timestamp of the [WorkoutReading] in milliseconds.
  final timestamp = DateTime.now().millisecondsSinceEpoch;

  /// The sensor the data was collected from.
  final WorkoutSensor sensor;

  /// The value of the sensor reading.
  final double value;

  WorkoutReading._(this.sensor, this.value);
}

enum WorkoutSensor {
  /// An unknown sensor type
  unknown,

  /// Heart rate sensor
  heartRate,
}
