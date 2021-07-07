# workout

Run a workout session and get live health data from Wear OS and Tizen.

## Getting Started

### Wear OS
Health Services for Wear OS are currently in developer preview

build.gradle:
`minSdkVersion 30`

Create `android/app/src/main/res/drawable/flutter_workout_service_icon.png` with your desired foreground service icon.

### Tizen

This plugin requires Tizen 5.5+.

Make the following changes to `tizen/tizen-manifest.xml`:
```
<manifest api-version="5.5" ...>
    <privileges>
        <privilege>http://tizen.org/privilege/healthinfo</privilege>
    </privileges>
    <feature name="http://tizen.org/feature/sensor.heart_rate_monitor">true</feature>
    <feature name="http://tizen.org/feature/sensor.pedometer">true</feature>
</manifest>
```

## Supported data types

| Feature     | Wear OS     | Tizen       |
| ----------- | ----------- | ----------- |
| Heart rate  | Yes         | Yes         |
| Calories    | Yes         | Yes         |
| Step count  | Yes         | Yes         |
| Speed       | Yes         | Yes         |
| Distance    | Yes         | Yes         |