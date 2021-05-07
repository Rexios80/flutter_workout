part of 'workout.dart';

class WorkoutReading {
  /// The timestamp of the [WorkoutReading] in milliseconds.
  final timestamp = DateTime.now().millisecondsSinceEpoch;

  /// The sensor the data was collected from.
  final WorkoutSensor sensor;

  /// The type of data collected.
  final WorkoutFeature feature;

  /// The value of the sensor reading.
  final double value;

  WorkoutReading._(this.sensor, this.feature, this.value);
}

enum WorkoutSensor {
  /// An unknown sensor type
  unknown,

  /// Heart rate
  heartRate,

  /// Pedometer (steps, distance, calories, speed)
  pedometer,
}

enum WorkoutFeature {
  /// An unknown workout feature
  unknown,

  /// Heart rate
  heartRate,

  /// Steps taken
  steps,

  /// Distance traveled in meters
  distance,

  /// Calories burned
  calories,

  /// Speed in km/h
  speed,
}
