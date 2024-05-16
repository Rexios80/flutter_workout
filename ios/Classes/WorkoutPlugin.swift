import Flutter
import HealthKit
import UIKit

public class WorkoutPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "workout", binaryMessenger: registrar.messenger())
        let instance = WorkoutPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "startWatchApp":
            startWatchApp(call, result: result)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func startWatchApp(_ call: FlutterMethodCall, result: FlutterResult) {
        let configuration = HKWorkoutConfiguration()
        configuration.activityType = .americanFootball
        configuration.locationType = .outdoor
    }
}
