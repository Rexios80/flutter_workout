/// This enumerated type is used to represent the location type of a swimming workout.
///
/// iOS only
enum WorkoutSwimmingLocationType {
  /// unknown
  unknown(0),

  /// pool
  pool(1),

  /// openWater
  openWater(2);

  /// The unique identifier for this location type
  final int id;

  const WorkoutSwimmingLocationType(this.id);
}
