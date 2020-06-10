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

final class AppStore: ObservableObject {
  @Published private(set) var state: AppState {
    didSet {
      save()
    }
  }
  
  init() {
    if let savedState = UserDefaults.standard.object(forKey: "jewelState") as? Data {
      do {
        state = try JSONDecoder().decode(AppState.self, from: savedState)
        print("Loaded state")
        return
      } catch {
        print(error)
      }
    }
    
    let options = Options()
    let library = Library(userCollection: Collection(), sharedCollections: [Collection]())
    let appState = AppState(options: options, library: library)
    self.state = appState
  }
  
  public func update(action: AppAction) {
    state = updateState(appState: state, action: action)
  }
  
  private func save() {
    do {
      let encodedState = try JSONEncoder().encode(state)
      UserDefaults.standard.set(encodedState, forKey: "jewelState")
      print("Saved state")
    } catch {
      print(error)
    }
  }
  
 static func cardHeight(viewHeight: CGFloat) -> CGFloat {
    switch viewHeight {
    case 852...:
      return 94
    case 673..<852:
      return 71
    default:
      return 61
    }
  }
    
}
