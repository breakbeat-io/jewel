//
//  StatePersitenceManager.swift
//  Stacks
//
//  Created by Greg Hepworth on 29/08/2023.
//  Copyright © 2023 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct StatePersitenceManager {
  
  private static let stateVersionKey = "jewelState_3_0"
  
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
    
    StateMigrations.runMigrations()
    
    return savedState() ?? newState()
    
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
  
  struct StateMigrations {
    
    fileprivate static func runMigrations() {
      migrateV2p0ToV2p1()
      migrateV2p1ToV3p0()
    }
    
    private static func migrateV2p1ToV3p0() {
      
      JewelLogger.persistence.info("💎 Persistence > Looking for a v2.1 saved state")
      guard let v2p1StateData = UserDefaults.standard.object(forKey: "jewelState_2_1") as? Data else {
        JewelLogger.persistence.info("💎 Persistence > No v2.1 saved state found")
        return
      }
      
      JewelLogger.persistence.info("💎 Persistence > Found a v2.1 saved state, migrating to v3.0")
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let v2p1State = try decoder.decode(AppStateV2p1.self, from: v2p1StateData)
        
        let v3p0Settings = Settings(preferredMusicPlatform: v2p1State.settings.preferredMusicPlatform, firstTimeRun: false)
        
        var v3p0OnRotationSlots = [Slot]()
        for v2p1OnRotationSlot in v2p1State.library.onRotation.slots {
          let v3p0OnRotationSlot = Slot(id: v2p1OnRotationSlot.id,
                                        album: v2p1OnRotationSlot.album,
                                        playbackLinks: v2p1OnRotationSlot.playbackLinks)
          v3p0OnRotationSlots.append(v3p0OnRotationSlot)
        }
        
        let v3p0OnRotationStack = Stack(id: v2p1State.library.onRotation.id,
                                        name: v2p1State.library.onRotation.name,
                                        slots: v3p0OnRotationSlots)
        
        var v3p0Stacks = [Stack]()
        for v2p1Collection in v2p1State.library.collections {
          var v3p0StackSlots = [Slot]()
          for v2p1CollectionSlot in v2p1Collection.slots {
            let v3p0StackSlot = Slot(id: v2p1CollectionSlot.id,
                                     album: v2p1CollectionSlot.album,
                                     playbackLinks: v2p1CollectionSlot.playbackLinks)
            v3p0StackSlots.append(v3p0StackSlot)
          }
          
          let v3p0Stack = Stack(id: v2p1Collection.id,
                                name: v2p1Collection.name,
                                slots: v3p0StackSlots)
          v3p0Stacks.append(v3p0Stack)
        }
        
        let v3p0Library = Library(onRotation: v3p0OnRotationStack,
                                     stacks: v3p0Stacks)
        
        let v3p0State = AppState(settings: v3p0Settings,
                                    library: v3p0Library)
        
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let encodedState = try encoder.encode(v3p0State)
        UserDefaults.standard.set(encodedState, forKey: stateVersionKey)
        
        JewelLogger.persistence.info("💎 Persistence > Migration successful, deleting v2.1 saved state")
        UserDefaults.standard.removeObject(forKey: "jewelState_2_1")
        
        UserDefaults.standard.synchronize()
        
      } catch {
        JewelLogger.persistence.debug("💎 Persistence > Error migrating a v2.1 state: \(error.localizedDescription)")
        return
      }
      
    }
    
    private static func migrateV2p0ToV2p1() {
      
      JewelLogger.persistence.info("💎 Persistence > Looking for a v2.0 saved state")
      
      guard let v2p0StateData = UserDefaults.standard.object(forKey: "jewelState") as? Data else {
        JewelLogger.persistence.info("💎 Persistence > No v2.0 saved state found")
        return
      }
      
      JewelLogger.persistence.info("💎 Persistence > Found a v2.0 saved state, migrating to v2.1")
      
      do {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let v2p0State = try decoder.decode(AppStateV2p0.self, from: v2p0StateData)
        
        let v2p1Settings = AppStateV2p1.Settings(preferredMusicPlatform: OdesliPlatform.allCases[v2p0State.settings.preferredMusicPlatform],
                                                 firstTimeRun: false)
        
        var v2p1OnRotationSlots = [AppStateV2p1.Slot]()
        for v2p0OnRotationSlot in v2p0State.library.onRotation.slots {
          let v2p1OnRotationSlot = AppStateV2p1.Slot(id: v2p0OnRotationSlot.id,
                                       album: v2p0OnRotationSlot.album,
                                       playbackLinks: v2p0OnRotationSlot.playbackLinks)
          v2p1OnRotationSlots.append(v2p1OnRotationSlot)
        }

        let v2p1OnRotation = AppStateV2p1.Collection(id: v2p0State.library.onRotation.id,
                                                    name: v2p0State.library.onRotation.name,
                                                    slots: v2p1OnRotationSlots)
        
        var v2p1Collections = [AppStateV2p1.Collection]()
        for v2p0Collection in v2p0State.library.collections {
          var v2p1CollectionSlots = [AppStateV2p1.Slot]()
          for v2p0CollectionSlot in v2p0Collection.slots {
            let v2p1CollectionSlot = AppStateV2p1.Slot(id: v2p0CollectionSlot.id,
                                                       album: v2p0CollectionSlot.album,
                                                       playbackLinks: v2p0CollectionSlot.playbackLinks)
            v2p1CollectionSlots.append(v2p1CollectionSlot)
          }
          let v2p1Collection = AppStateV2p1.Collection(id: v2p0Collection.id,
                                                       name: v2p0Collection.name,
                                                       slots: v2p1CollectionSlots)
          v2p1Collections.append(v2p1Collection)
        }
        
        let v2p1Library = AppStateV2p1.Library(onRotation: v2p1OnRotation,
                                               collections: v2p1Collections)

        let v2p1State = AppStateV2p1(settings: v2p1Settings,
                                     library: v2p1Library)
        

        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        let encodedState = try encoder.encode(v2p1State)
        UserDefaults.standard.set(encodedState, forKey: "jewelState_2_1")
        
        JewelLogger.persistence.info("💎 Persistence > Migration successful, deleting v2.0 saved state")
        UserDefaults.standard.removeObject(forKey: "jewelState")
        
        UserDefaults.standard.synchronize()
        
      } catch {
        JewelLogger.persistence.debug("💎 Persistence > Error migrating a v2.0 state: \(error.localizedDescription)")
      }
      
    }
  }
  
}
