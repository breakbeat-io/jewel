//
//  Store.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import UIKit
import HMV

final class AppEnvironment: ObservableObject {
  
  static let global = AppEnvironment()
  
  @Published var navigation: Navigation
  @Published private(set) var state: AppState {
    didSet {
      save()
    }
  }
  
  private init() {
    
    if let savedState = UserDefaults.standard.object(forKey: "jewelState") as? Data {
      do {
        let decodedSavedState = try JSONDecoder().decode(AppState.self, from: savedState)
        state = decodedSavedState
        print("💎 State > Loaded state")
        
        let onRotationId = decodedSavedState.library.onRotation.id
        navigation = Navigation(onRotationId: onRotationId, activeCollectionId: onRotationId)
        print("💎 Navigation > Initialised")
        
        return
      } catch {
        print("💎 State > Error loading state: \(error)")
      }
    }
    
    print("💎 State > No saved state found, creating new")
    let options = Options()
    let onRotationCollection = Collection(type: .userCollection, name: Navigation.Tab.onRotation.rawValue, curator: options.defaultCurator)
    let library = Library(onRotation: onRotationCollection, collections: [Collection]())
    
    state = AppState(options: options, library: library)
    print("💎 State > New state created")
    
    let onRotationId = onRotationCollection.id
    navigation = Navigation(onRotationId: onRotationId, activeCollectionId: onRotationId)
    print("💎 Navigation > Initialised")
    
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
      print("💎 State > Error saving state: \(error)")
    }
  }
  
  private func migrateV1UserDefaults() {
    
    if UserDefaults.standard.string(forKey: "collectionName") != nil {
      print("💎 State Migration > v1.0 Collection Name found ... deleting.")
      UserDefaults.standard.removeObject(forKey: "collectionName")
    }
    
    if let savedCollection = UserDefaults.standard.dictionary(forKey: "savedCollection") {
      print("💎 State Migration > v1.0 Saved Collection found ... migrating.")
      for slotIndex in 0..<state.library.onRotation.slots.count {
        if let appleMusicAlbumId = savedCollection[String(slotIndex)] {
          RecordStore.purchase(album: appleMusicAlbumId as! String, forSlot: slotIndex, inCollection: state.library.onRotation.id)
        }
      }
      UserDefaults.standard.removeObject(forKey: "savedCollection")
    }
    
  }
  
}
