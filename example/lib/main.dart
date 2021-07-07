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
  final workout = Workout();
  final features = [
    WorkoutFeature.heartRate,
    WorkoutFeature.calories,
    WorkoutFeature.steps,
    WorkoutFeature.distance,
    WorkoutFeature.speed,
  ];

  double heartRate = 0;
  bool started = false;

  _MyAppState() {
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
          child: Column(
            children: [
              Spacer(),
              Text('Heart rate: $heartRate'),
              Spacer(),
              TextButton(
                onPressed: () => setState(() {
                  started = !started;
                  if (started) {
                    workout.start(features);
                  } else {
                    workout.stop();
                  }
                }),
                child: Text(started ? 'Stop' : 'Start'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
