//
//  NavigationActions.swift
//  Stacks
//
//  Created by Greg Hepworth on 03/07/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import SwiftUI

enum NavigationAction: AppAction {
  
  case switchTab(to: Navigation.Tab)
  case setActiveStackId(stackId: UUID)
  case setActiveSlotIndex(slotIndex: Int)
  case showSettings(Bool)
  case showSearch(Bool)
  case showStack(Bool)
  case showStackOptions(Bool)
  case showLibraryOptions(Bool)
  case showAlbumDetail(Bool)
  case showPlaybackLinks(Bool)
  case gettingPlaybackLinks(Bool)
  case gettingSearchResults(Bool)
  case setStackViewHeight(viewHeight: CGFloat)
  case setLibraryViewHeight(viewHeight: CGFloat)
  case reset
  case toggleDebug
  
  var description: String {
    switch self {
    case .switchTab(let tab):
      return "\(type(of: self)): Switching to \(tab.rawValue) tab"
    case .setActiveStackId(let stackId):
      return "\(type(of: self)): Setting active stack to \(stackId)"
    case .setActiveSlotIndex(let slotId):
      return "\(type(of: self)): Setting active slot to \(slotId)"
    case .showSettings(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") settings"
    case .showSearch(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") search"
    case .showStack(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") stack"
    case .showStackOptions(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") stack options"
    case .showLibraryOptions(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") library options"
    case .showAlbumDetail(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") album detail"
    case .showPlaybackLinks(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") alternative links"
    case .gettingPlaybackLinks(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Hiding") playback links spinner"
    case .gettingSearchResults(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") search spinner"
    case .setStackViewHeight(let height):
      return "\(type(of: self)): Setting stack view height to \(height)"
    case .setLibraryViewHeight(let height):
      return "\(type(of: self)): Setting library view height to \(height)"
    case .reset:
      return "\(type(of: self)): Resetting navigation to defaults"
    case .toggleDebug:
      return "\(type(of: self)): Toggling debug"
    }
  }
  
  func update(_ state: AppState) -> AppState {
    
    var newState = state
    
    switch self {
      
    case let .switchTab(toTab):
      newState.navigation.selectedTab = toTab
      
    case let .setActiveStackId(stackId):
      newState.navigation.activeStackId = stackId
      
    case let .setActiveSlotIndex(slotIndex):
      newState.navigation.activeSlotIndex = slotIndex
      
    case let .showSettings(showSettingsState):
      newState.navigation.showSettings = showSettingsState
      
    case let .showSearch(showSearchState):
      newState.navigation.showSearch = showSearchState
      
    case let .showStack(showStackState):
      newState.navigation.showStack = showStackState
      
    case let .showStackOptions(showStackOptionsState):
      newState.navigation.showStackOptions = showStackOptionsState
      
    case let .showLibraryOptions(showLibraryOptionsState):
      newState.navigation.showLibraryOptions = showLibraryOptionsState
      
    case let .showAlbumDetail(showAlbumDetailState):
      newState.navigation.showAlbumDetail = showAlbumDetailState
      
    case let .showPlaybackLinks(showPlaybackLinksState):
      newState.navigation.showPlaybackLinks = showPlaybackLinksState
      
    case let .gettingPlaybackLinks(gettingPlaybackLinksState):
      newState.navigation.gettingPlaybackLinks = gettingPlaybackLinksState
      
    case let .gettingSearchResults(gettingSearchResultsState):
      newState.navigation.gettingSearchResults = gettingSearchResultsState
      
    case let .setStackViewHeight(viewHeight):
      newState.navigation.stackViewHeight = viewHeight
      
    case let .setLibraryViewHeight(viewHeight):
      newState.navigation.libraryViewHeight = viewHeight
      
    case .reset:
      newState.navigation = Navigation(onRotationId: newState.navigation.onRotationId, activeStackId: newState.navigation.activeStackId)
      
    case .toggleDebug:
      newState.navigation.showDebugMenu.toggle()
      
    }
    
    return newState
    
  }
  
  
}
