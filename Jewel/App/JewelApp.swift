//
//  JewelApp.swift
//  Listen Later
//
//  Created by Greg Hepworth on 27/09/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import os.log

@main
struct JewelApp: App {
  
  init() {
    let appleMusicApiToken = Bundle.main.infoDictionary?["APPLE_MUSIC_API_TOKEN"] as! String
    if appleMusicApiToken == "" {
      fatalError("No Apple Music API Token Found!")
    }
  }
  
  var body: some Scene {
    WindowGroup {
      Home()
        .environmentObject(AppEnvironment.global)
        .onOpenURL { url in
          SharedCollectionManager.cueReceivedCollection(receivedCollectionUrl: url)
        }
    }
  }
  
}
