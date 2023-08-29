//
//  StateManager.swift
//  Listen Later
//
//  Created by Greg Hepworth on 29/08/2023.
//  Copyright © 2023 Breakbeat Ltd. All rights reserved.
//

import Foundation
import os.log

struct StateManager {
  
  static func save(_ state: AppState, key: String) {
    do {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      let encodedState = try encoder.encode(state)
      UserDefaults.standard.set(encodedState, forKey: key)
    } catch {
      os_log("💎 State > Error saving state: %s", error.localizedDescription)
    }
  }
  
  static func loadSavedState(_ key: String) -> AppState? {
    os_log("💎 State > Looking for a current saved state")
    guard let savedState = UserDefaults.standard.object(forKey: key) as? Data else { return nil }
    
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
      os_log("💎 State > Error loading a current saved state: %s", error.localizedDescription)
      return nil
    }
    
  }
  
  static func createNewState() -> AppState {
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
