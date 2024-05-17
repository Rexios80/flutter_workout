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
        Text("Send config from phone")
        if let activityType = mainEO.activityType {
            Text("Activity Type: \(activityType)")
        }
        if let locationType = mainEO.locationType {
            Text("Location Type: \(locationType)")
        }
        if let swimmingLocationType = mainEO.swimmingLocationType {
            Text("Swimming Location Type: \(swimmingLocationType)")
        }
        if let lapLength = mainEO.lapLength {
            Text("Lap Length: \(lapLength)")
        }
    }
}
