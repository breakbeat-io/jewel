//
//  StatePersitenceManager.swift
//  Stacks
//
//  Created by Greg Hepworth on 29/08/2023.
//  Copyright © 2023 Breakbeat Ltd. All rights reserved.
//

import Foundation
import os.log

struct StatePersitenceManager {
  
  private static let stateVersionKey = "jewelState_2_1"
  
  static func save(_ state: AppState) {
    do {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      let encodedState = try encoder.encode(state)
      UserDefaults.standard.set(encodedState, forKey: stateVersionKey)
    } catch {
      os_log("💎 State > Error saving state: %s", error.localizedDescription)
    }
  }
  
  static func load() -> AppState {
    
    return oldSavedState() ?? savedState() ?? newState()
    
  }
  
  private static func oldSavedState() -> AppState? {
    
    os_log("💎 State > Looking for a pre-2.1.0 saved state")
    guard let oldSavedState = UserDefaults.standard.object(forKey: "jewelState") as? Data else {
      os_log("💎 State > No pre-2.1.0 saved state found")
      return nil
    }
    
    os_log("💎 State > Found a pre-2.1.0 saved state, migrating")
    if let state = migrateOldSavedState(oldSavedState) {
      os_log("💎 State > Migration successful, deleting pre-2.1.0 saved state")
      UserDefaults.standard.removeObject(forKey: "jewelState")
      return state
    } else {
      os_log("💎 State > Migration failed")
      return nil
    }
    
  }
  
  private static func migrateOldSavedState(_ oldSavedState: Data) -> AppState? {
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      let oldState = try decoder.decode(OldAppState.self, from: oldSavedState)

      var newState = StatePersitenceManager.newState()

      newState.settings.firstTimeRun = false
      newState.settings.preferredMusicPlatform = OdesliPlatform.allCases[oldState.settings.preferredMusicPlatform]
      
      let newOnRotation = Collection(id: oldState.library.onRotation.id,
                                           name: oldState.library.onRotation.name,
                                           slots: oldState.library.onRotation.slots)
      newState.library.onRotation = newOnRotation
      
      var newCollections = [Collection]()
      for oldCollection in oldState.library.collections {
        let newCollection = Collection(id: oldCollection.id,
                                       name: oldCollection.name,
                                       slots: oldCollection.slots)
        newCollections.append(newCollection)
      }
      newState.library.collections = newCollections
      
      return newState
      
    } catch {
      os_log("💎 State > Error decoding a pre-2.1.0 state: %s", error.localizedDescription)
      return nil
    }
  }
  
  static func savedState() -> AppState? {

    os_log("💎 State > Looking for a current saved state")
    guard let savedState = UserDefaults.standard.object(forKey: stateVersionKey) as? Data else {
      os_log("💎 State > No current saved state found")
      return nil
    }
    
    os_log("💎 State > Found a current saved state")
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      var state = try decoder.decode(AppState.self, from: savedState)
      state.navigation.onRotationId = state.library.onRotation.id
      state.navigation.activeCollectionId = state.library.onRotation.id
      os_log("💎 State > Loaded a current saved state")
      return state
    } catch {
      os_log("💎 State > Error decoding a current saved state: %s", error.localizedDescription)
      return nil
    }
    
  }
  
  static func newState() -> AppState {
    
    os_log("💎 State > Creating a new state")
    let onRotationCollection = Collection(name: Navigation.Tab.onRotation.rawValue)
    let library = Library(onRotation: onRotationCollection, collections: [Collection]())
    var state = AppState(settings: Settings(), library: library)
    state.navigation.onRotationId = onRotationCollection.id
    state.navigation.activeCollectionId = onRotationCollection.id
    os_log("💎 State > Created a new state")
    return state
  }
  
}
