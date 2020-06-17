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
  
  @Published private(set) var state: AppState {
    didSet {
      save()
    }
  }
  
  private init() {
    if let savedState = UserDefaults.standard.object(forKey: "jewelState") as? Data {
      do {
        state = try JSONDecoder().decode(AppState.self, from: savedState)
        print("💎 State > Loaded state")
        return
      } catch {
        print("💎 State > Error loading state: \(error)")
      }
    }
    
    let options = Options()
    let onRotationCollection = Collection(type: .userCollection, name: "On Rotation", curator: "A Music Lover")
    let library = Library(onRotation: onRotationCollection, sharedCollections: [Collection]())
    let appState = AppState(options: options, library: library)
    
    self.state = appState
    
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
    
    if let v1CollectionName = UserDefaults.standard.string(forKey: "collectionName") {
      print("💎 State Migration > v1.0 Collection Name found ... migrating.")
      state.library.onRotation.name = v1CollectionName
      UserDefaults.standard.removeObject(forKey: "collectionName")
    }
    
    if let savedCollection = UserDefaults.standard.dictionary(forKey: "savedCollection") {
      print("💎 State Migration > v1.0 Saved Collection found ... migrating.")
      for slotIndex in 0..<state.library.onRotation.slots.count {
        if let albumId = savedCollection[String(slotIndex)] {
          RecordStore.purchase(album: albumId as! String, forSlot: slotIndex, inCollection: state.library.onRotation.id)
        }
      }
      UserDefaults.standard.removeObject(forKey: "savedCollection")
    }
    
  }
  
}