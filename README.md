# workout

Run a workout session and get live health data from Wear OS and Tizen.

## Getting Started

### Wear OS

build.gradle:
`minSdkVersion 23`

AndroidManifest.xml:
`<uses-permission android:name="android.permission.BODY_SENSORS" />`

### Tizen

This plugin requires Tizen 5.5+.

Make the following changes to `tizen/tizen-manifest.xml`:
```
<manifest api-version="5.5" ...>
    <privileges>
        <privilege>http://tizen.org/privilege/healthinfo</privilege>
    </privileges>
    <feature name="http://tizen.org/feature/sensor.heart_rate_monitor">true</feature>
</manifest>
```

