# workout

Run a workout session and get live health data from Wear OS and Tizen.

## Getting Started

### Wear OS
Health Services for Wear OS are currently in developer preview

build.gradle:
`minSdkVersion 30`

[Add an ambient screen to your watch app](https://developer.android.com/training/wearables/health-services/active#maintain-presence)

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

| Feature     | Wear OS     | Tizen       |
| ----------- | ----------- | ----------- |
| Heart rate  | Yes         | Yes         |
| Calories    | Yes         | Yes         |
| Step count  | Untested    | Yes         |
| Speed       | Untested    | Yes         |
| Distance    | Untested    | Yes         |