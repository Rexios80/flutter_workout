# workout

Run a workout session and get live health data from Wear OS and Tizen. Also start a watchOS app from iOS.

## Getting Started

### Wear OS

Health Services for Wear OS are currently in beta

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

### iOS

Flutter cannot run on watchOS, but there is a method on iOS to start the watch app. This requires the `HealthKit` entitlement. Calling the `start` method on iOS will call `startWatchApp` with the given parameters.

## Supported data types

| Feature    | Wear OS | Tizen |
| ---------- | ------- | ----- |
| Heart rate | Yes     | Yes   |
| Calories   | Yes     | Yes   |
| Step count | Yes     | Yes   |
| Speed      | Yes     | Yes   |
| Distance   | Yes     | Yes   |
