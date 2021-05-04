# workout_example

```
final workout = Workout();
workout.start([WorkoutSensor.heartRate]);
workout.stream.listen((event) {
  print('${event.sensor}: ${event.value}');
  if (event.sensor == WorkoutSensor.heartRate) {
    setState(() {
      heartRate = event.value;
    });
  }
});
workout.stop();
```