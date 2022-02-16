import 'package:workout/src/model/workout_feature.dart';

/// The result of starting a workout session
class WorkoutStartResult {
  /// Wear OS: Requested features unsupported by the given exercise type
  /// 
  /// Tizen: Always empty
  final List<WorkoutFeature> unsupportedFeatures;

  WorkoutStartResult._({required this.unsupportedFeatures});

  WorkoutStartResult._empty() : this._(unsupportedFeatures: []);

  /// Create a [WorkoutStartResult] from a start result
  factory WorkoutStartResult.fromResult(Map<String, dynamic>? result) {
    if (result == null) return WorkoutStartResult._empty();

    final unsupportedFeaturesResult = result['unsupportedFeatures'] as List?;
    final List<WorkoutFeature> unsupportedFeatures;
    if (unsupportedFeaturesResult == null) {
      unsupportedFeatures = [];
    } else {
      unsupportedFeatures = unsupportedFeaturesResult
          .cast<String>()
          .map((e) => WorkoutFeature.values.byName(e))
          .toList();
    }

    return WorkoutStartResult._(unsupportedFeatures: unsupportedFeatures);
  }
}
