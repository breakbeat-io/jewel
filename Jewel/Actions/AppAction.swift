//
//  AppAction.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

protocol AppAction {
  var description: String { get }
}

func updateState(appState: AppState, action: AppAction) -> AppState {
  
  var newAppState = appState
  
  switch action {
    
  case is NavigationAction:
    newAppState.navigation = updateNavigation(navigation: newAppState.navigation, action: action as! NavigationAction)
    
  case is SettingsAction:
    newAppState.settings = updateSettings(settings: newAppState.settings, action: action as! SettingsAction)
    
  case is LibraryAction:
    newAppState.library = updateLibrary(library: newAppState.library, action: action as! LibraryAction)
    
  case is SearchAction:
    newAppState.search = updateSearch(search: newAppState.search, action: action as! SearchAction)
    
  case is DebugAction:
    newAppState = debugUpdate(state: newAppState, action: action as! DebugAction)
    
  default: break
    
  }
  
    JewelLogger.stateUpdate.info("💎 State Update > \(action.description)")
  
  return newAppState
}
