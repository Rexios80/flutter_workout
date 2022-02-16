import 'package:flutter/material.dart';
import 'package:workout/workout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final workout = Workout();
  final features = [
    WorkoutFeature.heartRate,
    WorkoutFeature.calories,
    WorkoutFeature.steps,
    WorkoutFeature.distance,
    WorkoutFeature.speed,
  ];

  double heartRate = 0;
  double calories = 0;
  double steps = 0;
  double distance = 0;
  double speed = 0;
  bool started = false;

  _MyAppState() {
    workout.stream.listen((event) {
      // ignore: avoid_print
      print('${event.feature}: ${event.value} (${event.timestamp})');
      switch (event.feature) {
        case WorkoutFeature.unknown:
          return;
        case WorkoutFeature.heartRate:
          setState(() {
            heartRate = event.value;
          });
          break;
        case WorkoutFeature.calories:
          setState(() {
            calories = event.value;
          });
          break;
        case WorkoutFeature.steps:
          setState(() {
            steps = event.value;
          });
          break;
        case WorkoutFeature.distance:
          setState(() {
            distance = event.value;
          });
          break;
        case WorkoutFeature.speed:
          setState(() {
            speed = event.value;
          });
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: Colors.black),
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Spacer(),
              Text('Heart rate: $heartRate'),
              Text('Calories: $calories'),
              Text('Steps: $steps'),
              Text('Distance: $distance'),
              Text('Speed: $speed'),
              const Spacer(),
              TextButton(
                onPressed: toggleExerciseState,
                child: Text(started ? 'Stop' : 'Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void toggleExerciseState() async {
    setState(() {
      started = !started;
    });

    if (started) {
      final supportedExerciseTypes = await workout.getSupportedExerciseTypes();
      // ignore: avoid_print
      print('Supported exercise types: ${supportedExerciseTypes.length}');

      final result = await workout.start(
        // In a real application, check the supported exercise types first
        exerciseType: ExerciseType.walking,
        features: features,
        enableGps: true,
      );

      if (result.unsupportedFeatures.isNotEmpty) {
        // ignore: avoid_print
        print('Unsupported features: ${result.unsupportedFeatures}');
        // In a real application, update the UI to match
      } else {
        // ignore: avoid_print
        print('All requested features supported');
      }
    } else {
      await workout.stop();
    }
  }
}
