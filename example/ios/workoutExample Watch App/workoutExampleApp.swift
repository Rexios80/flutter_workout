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

    init() {}

    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(MainEO.shared)
        }
    }
}

class MainEO: ObservableObject {
    static let shared = MainEO()

    private init() {}

    @Published var workoutConfiguration: HKWorkoutConfiguration?
}

class AppDelegate: NSObject, WKApplicationDelegate {
    func handle(_ workoutConfiguration: HKWorkoutConfiguration) {
        MainEO.shared.workoutConfiguration = workoutConfiguration
    }
}
