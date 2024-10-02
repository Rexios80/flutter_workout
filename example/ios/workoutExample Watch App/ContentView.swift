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
    ScrollView {
      VStack(alignment: .leading) {
        Text("Send config from phone")
        Spacer().frame(height: 10)
        if let activityType = mainEO.activityType {
          Text("Activity Type: \(activityType.rawValue)")
          Spacer().frame(height: 10)
        }
        if let locationType = mainEO.locationType {
          Text("Location Type: \(locationType.rawValue)")
          Spacer().frame(height: 10)
        }
        if let swimmingLocationType = mainEO.swimmingLocationType {
          Text("Swimming Location Type: \(swimmingLocationType.rawValue)")
          Spacer().frame(height: 10)
        }
        if let lapLength = mainEO.lapLength {
          Text("Lap Length: \(lapLength)")
        }
      }
    }
  }
}
