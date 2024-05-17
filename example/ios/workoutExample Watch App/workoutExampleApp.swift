//
//  workoutExampleApp.swift
//  workoutExample Watch App
//
//  Created by Rexios on 5/17/24.
//

import HealthKit
import SwiftUI

@main
struct workoutExample_Watch_AppApp: App {
    @WKApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(MainEO.shared)
        }
    }
}

class MainEO: ObservableObject {
    static let shared = MainEO()

    private init() {}

    @Published var activityType: HKWorkoutActivityType?
    @Published var locationType: HKWorkoutSessionLocationType?
    @Published var swimmingLocationType: HKWorkoutSwimmingLocationType?
    @Published var lapLength: Double?
}

class AppDelegate: NSObject, WKApplicationDelegate {
    func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
        MainEO.shared.activityType = workoutConfiguration.activityType
        MainEO.shared.locationType = workoutConfiguration.locationType
        MainEO.shared.swimmingLocationType = workoutConfiguration.swimmingLocationType
        MainEO.shared.lapLength = workoutConfiguration.lapLength?.doubleValue(for: .meter())
    }
}
