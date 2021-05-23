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
  
  init() {
    checkKeys()
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
  
  private func checkKeys() {
    if Secrets.appleMusicAPIToken.isEmpty {
      fatalError("""
==========
No Apple Music API Token Found! [APPLE_MUSIC_API_TOKEN]

Please make sure a valid Apple Music private key, ID and Developer Team ID are
set in secrets.xcconfig to allow a token to be generated on build by the
pre-action createAppleMusicAPIToken.sh
==========
""")
    }
    
    if Secrets.firebaseAPIKey.isEmpty {
      fatalError("""
==========
No Firebase API Key Found! [FIREBASE_API_KEY]

Please make sure a valid Firebase API key is set in secrets.xcconfig
to allow short links to be created for collection sharing.
==========
""")
    }
  }
  
}
