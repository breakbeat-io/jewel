//
//  Store.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import os.log
import UIKit
import HMV

final class AppEnvironment: ObservableObject {
  
  static let global = AppEnvironment()
  
  @Published private(set) var state: AppState {
    didSet {
      save()
    }
  }
  
  private init() {
    
    let appleMusicApiToken = Bundle.main.infoDictionary?["APPLE_MUSIC_API_TOKEN"] as! String
    if appleMusicApiToken == "" {
      fatalError("""
==========
No Apple Music API Token Found!

Please make sure a valid Apple Music private key, ID and Developer Team ID are
set in secrets.xcconfig to allow a token to be generated on build by the
pre-action createAppleMusicAPIToken.sh
==========
""")
    }
    
    if let savedState = UserDefaults.standard.object(forKey: "jewelState") as? Data {
      do {
        let decodedSavedState = try JSONDecoder().decode(AppState.self, from: savedState)
        state = decodedSavedState
        os_log("💎 State > Loaded state")
        
        let onRotationId = decodedSavedState.library.onRotation.id
        state.navigation.onRotationId = onRotationId
        state.navigation.activeCollectionId = onRotationId
        os_log("💎 Navigation > Initialised")
        
        return
      } catch {
        os_log("💎 State > Error loading state: %s", error.localizedDescription)
      }
    }
    
    os_log("💎 State > No saved state found, creating new")
    let settings = Settings()
    let onRotationCollection = Collection(type: .userCollection, name: Navigation.Tab.onRotation.rawValue, curator: "A Music Lover")
    let library = Library(onRotation: onRotationCollection, collections: [Collection]())
    
    state = AppState(settings: settings, library: library)
    os_log("💎 State > New state created")
    
    let onRotationId = onRotationCollection.id
    state.navigation.onRotationId = onRotationId
    state.navigation.activeCollectionId = onRotationId
    os_log("💎 Navigation > Initialised")
    
    migrateV1UserDefaults()
    
  }
  
  public func update(action: AppAction) {
    state = updateState(appState: state, action: action)
  }
  
  private func save() {
    do {
      let encodedState = try JSONEncoder().encode(state)
      UserDefaults.standard.set(encodedState, forKey: "jewelState")
    } catch {
      os_log("💎 State > Error saving state: %s", error.localizedDescription)
    }
  }
  
  private func migrateV1UserDefaults() {
    
    if UserDefaults.standard.string(forKey: "collectionName") != nil {
      os_log("💎 State Migration > v1.0 Collection Name found ... deleting.")
      UserDefaults.standard.removeObject(forKey: "collectionName")
    }
    
    if let savedCollection = UserDefaults.standard.dictionary(forKey: "savedCollection") {
      os_log("💎 State Migration > v1.0 Saved Collection found ... migrating.")
      for slotIndex in 0..<state.library.onRotation.slots.count {
        if let appleMusicAlbumId = savedCollection[String(slotIndex)] {
          RecordStore.purchase(album: appleMusicAlbumId as! String, forSlot: slotIndex, inCollection: state.library.onRotation.id)
        }
      }
      UserDefaults.standard.removeObject(forKey: "savedCollection")
    }
    
  }
  
}
