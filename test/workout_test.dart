import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout/workout.dart';

void main() {
  const MethodChannel channel = MethodChannel('workout');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Workout.platformVersion, '42');
  });
}
