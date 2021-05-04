
import 'dart:async';

import 'package:flutter/services.dart';

class Workout {
  static const MethodChannel _channel =
      const MethodChannel('workout');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
