//
//  ContentView.swift
//  workoutExample Watch App
//
//  Created by Rexios on 5/17/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var mainEO: MainEO

    var body: some View {
        if let config = mainEO.workoutConfiguration {
            Text("""
            Activity Type: \(config.activityType)
            Location Type: \(config.locationType)
            Swimming Location Type: \(config.swimmingLocationType)
            Lap Length: \(String(describing: config.lapLength))
            """)
        } else {
            Text("No workout configuration")
        }
    }
}
