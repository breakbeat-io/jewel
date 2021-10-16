//
//  JewelApp.swift
//  Listen Later
//
//  Created by Greg Hepworth on 27/09/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

@main
struct JewelApp: App {
  
  var body: some Scene {
    WindowGroup {
      Home()
        .environmentObject(AppEnvironment.global)
        .onOpenURL { url in
          Task {
            await SharedCollectionManager.cueReceivedCollection(receivedCollectionUrl: url)
          }
        }
    }
  }
  
}
