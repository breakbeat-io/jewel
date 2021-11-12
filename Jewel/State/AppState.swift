//
//  AppState.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import os.log
import MusicKit

struct AppState: Codable {
  
  var navigation = Navigation()
  
  var settings: Settings
  var library: Library
  var search = Search()
  
  enum CodingKeys: String, CodingKey {
    case settings
    case library
  }
}

extension AppState {
  
  static func save(_ state: AppState) {
    do {
      let encodedState = try JSONEncoder().encode(state)
      UserDefaults.standard.set(encodedState, forKey: "JewelAppState_V2")
    } catch {
      os_log("💎 State > Error saving state: %s", error.localizedDescription)
    }
  }
  
  static func loadSavedState() -> AppState? {
    os_log("💎 State > Looking for a current saved state")
    guard let savedState = UserDefaults.standard.object(forKey: "JewelAppState_V2") as? Data else { return nil }
    
    os_log("💎 State > Found a current saved state")
    do {
      var state = try JSONDecoder().decode(AppState.self, from: savedState)
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
    let onRotationCollection = Collection(type: .userCollection, name: Navigation.Tab.onRotation.rawValue, curator: "A Music Lover")
    let library = Library(onRotation: onRotationCollection, collections: [Collection]())
    var state = AppState(settings: Settings(), library: library)
    state.navigation.onRotationId = onRotationCollection.id
    state.navigation.activeCollectionId = onRotationCollection.id
    os_log("💎 State > Created a new state")
    return state
  }
  
  static func migrate() {
    os_log("💎 State Migration > Migrating any old state found")
    migrateAndRemoveV0State()
    migrateAndRemoveV1State()
  }
  
  static private func migrateAndRemoveV0State() {
    
    if UserDefaults.standard.string(forKey: "collectionName") != nil {
      os_log("💎 State Migration > v0 Collection Name found ... deleting")
      UserDefaults.standard.removeObject(forKey: "collectionName")
    }
    
    if let savedCollection = UserDefaults.standard.dictionary(forKey: "savedCollection") {
      os_log("💎 State Migration > v0 Saved Collection found ... migrating and deleting")
      for slotIndex in 0..<AppEnvironment.global.state.library.onRotation.slots.count {
        if let appleMusicAlbumId = savedCollection[String(slotIndex)] {
          Task {
            do {
              async let album = RecordStore.getAlbum(withId: MusicItemID(rawValue: appleMusicAlbumId as! String))
              try await AppEnvironment.global.update(action: LibraryAction.addSourceToSlot(source: album, slotIndex: slotIndex, collectionId: AppEnvironment.global.state.library.onRotation.id))
            } catch {
              os_log("💎 State Migration > Unable to migrate v0 Saved Collection: \(error.localizedDescription)")
            }
          }
        }
      }
      UserDefaults.standard.removeObject(forKey: "savedCollection")
    }
    
  }
  
  
  static private func migrateAndRemoveV1State() {
    
    guard let savedV1State = UserDefaults.standard.object(forKey: "jewelState") as? Data else { return }
    
    os_log("💎 State Migration > v1 saved state found ... migrating")
    
    do {
      let v1State = try JSONDecoder().decode(AppStateV1.self, from: savedV1State)
      
      Task {
        // Note, I was unable to use TaskGroup's here for the RecordStore loops as the speed of requests then exceeded Apple Music API limits and some would fail.  Throttling with concurrency appears non-trivial, therefore await-ing each request, but in a Task to occur without blocking.
        
        os_log("💎 State Migration > Migrating v1 Settings")
        await AppEnvironment.global.update(action: SettingsAction.setPreferredPlatform(platform: v1State.settings.preferredMusicPlatform))
        await AppEnvironment.global.update(action: SettingsAction.firstTimeRun(v1State.settings.firstTimeRun))
        
        os_log("💎 State Migration > Migrating v1 On Rotation")
        await AppEnvironment.global.update(action: LibraryAction.setCollectionCurator(curator: v1State.library.onRotation.curator, collectionId: AppEnvironment.global.state.library.onRotation.id))
        
        for (slotIndex, slot) in v1State.library.onRotation.slots.enumerated() {
          if let source = slot.source {
            async let album = RecordStore.getAlbum(withId: source.id)
            try await AppEnvironment.global.update(action: LibraryAction.addSourceToSlot(source: album, slotIndex: slotIndex, collectionId: AppEnvironment.global.state.library.onRotation.id))
          }
        }
        
        os_log("💎 State Migration > Migrating v1 Collections")
        for oldCollection in v1State.library.collections {
          let newCollection = Collection(type: oldCollection.type, name: oldCollection.name, curator: oldCollection.curator)
          await AppEnvironment.global.update(action: LibraryAction.addCollection(collection: newCollection))
          for (slotIndex, slot) in oldCollection.slots.enumerated() {
            if let source = slot.source {
              async let album = RecordStore.getAlbum(withId: source.id)
              try await AppEnvironment.global.update(action: LibraryAction.addSourceToSlot(source: album, slotIndex: slotIndex, collectionId: newCollection.id))
            }
          }
        }
        
        os_log("💎 State Migration > v1 Migration complete")
      }
    } catch {
      os_log("💎 State Migration > Unable to migrate v1 saved state: %s", error.localizedDescription)
    }
    
    // By now, I've either migrated to v2 or failed, but in either case there is nothing I can do with the original state, so let's remove it so migration isn't attempted again.
    os_log("💎 State Migration > Removing v1 saved state")
    UserDefaults.standard.removeObject(forKey: "jewelState")
    
  }
  
}
