# workout

Run a workout session and get live health data from Wear OS and Tizen.

## Getting Started

### Wear OS
Health Services for Wear OS are currently in developer preview

android/app/build.gradle:

`minSdkVersion 30`

android/app/src/main/AndroidManifest.xml:
```xml
<!-- Required for heart rate -->
<uses-permission android:name="android.permission.BODY_SENSORS" />
<!-- Required for calories, steps, distance, speed -->
<uses-permission android:name="android.permission.ACTIVITY_RECOGNITION" />
<!-- Required to use location to estimate distance, speed -->
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

### Tizen

This plugin requires Tizen 4.0+.

Make the following changes to `tizen/tizen-manifest.xml`:
```
<manifest api-version="4.0" ...>
    <privileges>
        <privilege>http://tizen.org/privilege/healthinfo</privilege>
    </privileges>
    <feature name="http://tizen.org/feature/sensor.heart_rate_monitor">true</feature>
    <feature name="http://tizen.org/feature/sensor.pedometer">true</feature>
</manifest>
```

## Supported data types

| Feature    | Wear OS                      | Tizen |
| ---------- | ---------------------------- | ----- |
| Heart rate | Yes                          | Yes   |
| Calories   | Yes                          | Yes   |
| Step count | Not working on Galaxy Watch4 | Yes   |
| Speed      | Yes                          | Yes   |
| Distance   | Yes                          | Yes   |