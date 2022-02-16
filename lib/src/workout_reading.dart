/// A sensor reading collected from the watch
class WorkoutReading {
  /// The timestamp of the [WorkoutReading]
  final DateTime timestamp;

  /// The type of data collected.
  final WorkoutFeature feature;

  /// The value of the sensor reading.
  final double value;

  /// Constructor
  WorkoutReading(this.feature, this.value, int? timestamp)
      : timestamp = timestamp != null
            ? DateTime.fromMillisecondsSinceEpoch(timestamp)
            : DateTime.now();
}

/// The features a workout reading can have
enum WorkoutFeature {
  /// An unknown workout feature
  unknown,

  /// Heart rate
  heartRate,

  /// Calories burned
  calories,

  /// Steps taken
  steps,

  /// Distance traveled in meters
  distance,

  /// Speed in km/h
  speed,
}
