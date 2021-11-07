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

final class AppEnvironment: ObservableObject {
  
  static let global = AppEnvironment()
  
  @Published private(set) var state: AppState {
    didSet {
      AppState.save(state)
    }
  }
  
  private init() {
    if let savedState = AppState.loadSavedState() {
      state = savedState
    } else {
      os_log("💎 State > No current saved state found, creating new")
      state = AppState.createNewState()
      AppState.migrate()
    }
  }
  
  @MainActor public func update(action: AppAction) {
    state = updateState(appState: state, action: action)
  }
  
}
