/// This enumerated type is used to represent the location type of a workout session.
///
/// iOS only
enum WorkoutLocationType {
  /// unknown
  unknown(1),

  /// indoor
  indoor(2),

  /// outdoor
  outdoor(3);

  /// The unique identifier for this location type
  final int id;

  const WorkoutLocationType(this.id);
}
