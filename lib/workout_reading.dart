part of 'workout.dart';

class WorkoutReading {
  /// The timestamp of the [WorkoutReading] in milliseconds.
  final timestamp = DateTime.now().millisecondsSinceEpoch;

  /// The sensor the data was collected from.
  final WorkoutSensor sensor;

  /// The value of the sensor reading.
  final List<double> values;

  WorkoutReading._(this.sensor, this.values);
}

enum WorkoutSensor {
  /// An unknown sensor type
  unknown,

  /// Heart rate in bpm
  heartRate,

  /// Calories burned
  calories,

  /// Pedometer (steps, distance, speed)
  pedometer,
}
