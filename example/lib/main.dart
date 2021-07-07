import 'package:flutter/material.dart';
import 'package:workout/workout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  double heartRate = 0;

  _MyAppState() {
    final workout = Workout();
    workout.start([
      WorkoutFeature.heartRate,
      WorkoutFeature.calories,
      WorkoutFeature.steps,
      WorkoutFeature.distance,
      WorkoutFeature.speed,
    ]);
    workout.stream.listen((event) {
      print('${event.feature}: ${event.value}');
      if (event.feature == WorkoutFeature.heartRate) {
        setState(() {
          heartRate = event.value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Heart rate: $heartRate'),
        ),
      ),
    );
  }
}
