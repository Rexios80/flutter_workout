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
        case "start":
            Task { await startWatchApp(call, result: result) }
        case "stop":
            result(nil)
        default:
            result(FlutterMethodNotImplemented)
        }
    }

    func startWatchApp(_ call: FlutterMethodCall, result: FlutterResult) async {
        let arguments = call.arguments as! [String: Any]

        let configuration = HKWorkoutConfiguration()
        if let activityTypeId = arguments["exerciseType"] as! Int?, let activityType = HKWorkoutActivityType(rawValue: UInt(activityTypeId)) {
            configuration.activityType = activityType
        }
        if let locationTypeId = arguments["locationType"] as! Int?, let locationType = HKWorkoutSessionLocationType(rawValue: locationTypeId) {
            configuration.locationType = locationType
        }
        if let swimmingLocationTypeId = arguments["swimmingLocationType"] as! Int?, let swimmingLocationType = HKWorkoutSwimmingLocationType(rawValue: swimmingLocationTypeId) {
            configuration.swimmingLocationType = swimmingLocationType
        }
        if let lapLength = arguments["lapLength"] as! Double? {
            configuration.lapLength = HKQuantity(unit: HKUnit.meter(), doubleValue: lapLength)
        }

        do {
            try await HKHealthStore().startWatchApp(toHandle: configuration)
            result(nil)
        } catch {
            result(FlutterError(code: "start_error", message: "Failed to start watch app", details: error.localizedDescription))
        }
    }
}
