import 'package:workout/src/model/workout_feature.dart';

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
            : DateTime.timestamp();
}
