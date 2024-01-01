//
//  JewelApp.swift
//  Stacks
//
//  Created by Greg Hepworth on 27/09/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import OSLog
import SwiftUI
import MusicKit

@main
struct JewelApp: App {
  
  @State var appleMusicAuthorizationStatus = MusicAuthorization.currentStatus
  
  var body: some Scene {
    WindowGroup {
      if appleMusicAuthorizationStatus != .authorized {
        AppleMusicAuthorization(appleMusicAuthorizationStatus: $appleMusicAuthorizationStatus)
      } else {
        Home()
          .environmentObject(AppEnvironment.global)
      }
    }
  }
  
}

struct JewelLogger {
    static let persistence = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "persistence")
    static let stateUpdate = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "stateUpdate")
    static let recordStore = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "recordStore")
    static let debugAction = Logger(subsystem: Bundle.main.bundleIdentifier!, category: "debugAction")
}
