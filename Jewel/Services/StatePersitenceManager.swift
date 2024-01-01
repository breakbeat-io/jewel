//
//  StatePersitenceManager.swift
//  Stacks
//
//  Created by Greg Hepworth on 29/08/2023.
//  Copyright © 2023 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct StatePersitenceManager {
  
  private static let stateVersionKey = "jewelState_2_1"
  
  static func save(_ state: AppState) {
    do {
      let encoder = JSONEncoder()
      encoder.keyEncodingStrategy = .convertToSnakeCase
      let encodedState = try encoder.encode(state)
      UserDefaults.standard.set(encodedState, forKey: stateVersionKey)
    } catch {
      JewelLogger.persistence.debug("💎 Persistence > Error saving state: \(error.localizedDescription)")
    }
  }
  
  static func load() -> AppState {
    
    return oldSavedState() ?? savedState() ?? newState()
    
  }
  
  private static func oldSavedState() -> AppState? {
    
    JewelLogger.persistence.info("💎 Persistence > Looking for a pre-2.1.0 saved state")
    guard let oldSavedState = UserDefaults.standard.object(forKey: "jewelState") as? Data else {
      JewelLogger.persistence.info("💎 Persistence > No pre-2.1.0 saved state found")
      return nil
    }
    
    JewelLogger.persistence.info("💎 Persistence > Found a pre-2.1.0 saved state, migrating")
    if let state = migrateOldSavedState(oldSavedState) {
      JewelLogger.persistence.info("💎 Persistence > Migration successful, deleting pre-2.1.0 saved state")
      UserDefaults.standard.removeObject(forKey: "jewelState")
      return state
    } else {
      JewelLogger.persistence.info("💎 Persistence > Migration failed")
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
      
      let newOnRotation = Stack(id: oldState.library.onRotation.id,
                                           name: oldState.library.onRotation.name,
                                           slots: oldState.library.onRotation.slots)
      newState.library.onRotation = newOnRotation
      
      var newStacks = [Stack]()
      for oldCollection in oldState.library.collections {  // From v3.0 Collections were renamed Stacks
        let newStack = Stack(id: oldCollection.id,
                                       name: oldCollection.name,
                                       slots: oldCollection.slots)
        newStacks.append(newStack)
      }
      newState.library.stacks = newStacks
      
      return newState
      
    } catch {
      JewelLogger.persistence.debug("💎 Persistence > Error decoding a pre-2.1.0 state: \(error.localizedDescription)")
      return nil
    }
  }
  
  static func savedState() -> AppState? {

    JewelLogger.persistence.info("💎 Persistence > Looking for a current saved state")
    guard let savedState = UserDefaults.standard.object(forKey: stateVersionKey) as? Data else {
      JewelLogger.persistence.info("💎 Persistence > No current saved state found")
      return nil
    }
    
    JewelLogger.persistence.info("💎 Persistence > Found a current saved state")
    do {
      let decoder = JSONDecoder()
      decoder.keyDecodingStrategy = .convertFromSnakeCase
      var state = try decoder.decode(AppState.self, from: savedState)
      state.navigation.onRotationId = state.library.onRotation.id
      state.navigation.activeStackId = state.library.onRotation.id
      JewelLogger.persistence.info("💎 Persistence > Loaded a current saved state")
      return state
    } catch {
      JewelLogger.persistence.debug("💎 Persistence > Error decoding a current saved state: \(error.localizedDescription)")
      return nil
    }
    
  }
  
  static func newState() -> AppState {
    
    JewelLogger.persistence.info("💎 Persistence > Creating a new state")
    let onRotationStack = Stack(name: Navigation.Tab.onRotation.rawValue)
    let library = Library(onRotation: onRotationStack, stacks: [Stack]())
    var state = AppState(settings: Settings(), library: library)
    state.navigation.onRotationId = onRotationStack.id
    state.navigation.activeStackId = onRotationStack.id
    JewelLogger.persistence.info("💎 Persistence > Created a new state")
    return state
  }
  
}
