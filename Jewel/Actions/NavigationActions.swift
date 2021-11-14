//
//  NavigationActions.swift
//  Listen Later
//
//  Created by Greg Hepworth on 03/07/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import SwiftUI

func updateNavigation(navigation: Navigation, action: NavigationAction) -> Navigation {
  
  var newNavigation = navigation
  
  switch action {
    
  case let .switchTab(toTab):
    newNavigation.selectedTab = toTab
  
  case let .setActiveCollectionId(collectionId):
    newNavigation.activeCollectionId = collectionId
    
  case let .setActiveSlotIndex(slotIndex):
    newNavigation.activeSlotIndex = slotIndex
  
  case let .showSettings(showSettingsState):
    newNavigation.showSettings = showSettingsState
    
  case let .showSearch(showSearchState):
    newNavigation.showSearch = showSearchState
    
  case let .showSharing(showSharingState):
    newNavigation.showSharing = showSharingState

  case let .showCollection(showCollectionState):
    newNavigation.showCollection = showCollectionState
  
  case let .showCollectionOptions(showCollectionOptionsState):
    newNavigation.showCollectionOptions = showCollectionOptionsState
  
  case let .showLibraryOptions(showLibraryOptionsState):
    newNavigation.showLibraryOptions = showLibraryOptionsState
    
  case let .showSourceDetail(showSourceDetailState):
    newNavigation.showSourceDetail = showSourceDetailState
  
  case let .showPlaybackLinks(showPlaybackLinksState):
    newNavigation.showPlaybackLinks = showPlaybackLinksState
    
  case let .gettingPlaybackLinks(gettingPlaybackLinksState):
    newNavigation.gettingPlaybackLinks = gettingPlaybackLinksState
    
  case let .gettingSearchResults(gettingSearchResultsState):
    newNavigation.gettingSearchResults = gettingSearchResultsState
  
  case let .shareLinkError(shareLinkErrorState):
    newNavigation.shareLinkError = shareLinkErrorState
    
  case let .showLoadRecommendationsAlert(loadRecommendationsAlertState):
    newNavigation.showLoadRecommendationsAlert = loadRecommendationsAlertState
    
  case let .setCollectionViewHeight(viewHeight):
    newNavigation.collectionViewHeight = viewHeight
  
  case let .setLibraryViewHeight(viewHeight):
  newNavigation.libraryViewHeight = viewHeight
  
  case .reset:
    newNavigation = Navigation(onRotationId: newNavigation.onRotationId, activeCollectionId: newNavigation.activeCollectionId)
    
  case .toggleDebug:
    newNavigation.showDebugMenu.toggle()
  
  }
  
  return newNavigation
  
}

enum NavigationAction: AppAction {
  
  case switchTab(to: Navigation.Tab)
  case setActiveCollectionId(collectionId: UUID)
  case setActiveSlotIndex(slotIndex: Int)
  case showSettings(Bool)
  case showSearch(Bool)
  case showSharing(Bool)
  case showCollection(Bool)
  case showCollectionOptions(Bool)
  case showLibraryOptions(Bool)
  case showSourceDetail(Bool)
  case showPlaybackLinks(Bool)
  case gettingPlaybackLinks(Bool)
  case gettingSearchResults(Bool)
  case shareLinkError(Bool)
  case showLoadRecommendationsAlert(Bool)
  case setCollectionViewHeight(viewHeight: CGFloat)
  case setLibraryViewHeight(viewHeight: CGFloat)
  case reset
  case toggleDebug
  
  var description: String {
    switch self {
    case .switchTab(let tab):
      return "\(type(of: self)): Switching to \(tab.rawValue) tab"
    case .setActiveCollectionId(let collectionId):
      return "\(type(of: self)): Setting active collection to \(collectionId)"
    case .setActiveSlotIndex(let slotId):
      return "\(type(of: self)): Setting active slot to \(slotId)"
    case .showSettings(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") settings"
    case .showSearch(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") search"
    case .showSharing(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") sharing"
    case .showCollection(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") collection"
    case .showCollectionOptions(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") collection options"
    case .showLibraryOptions(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") library options"
    case .showSourceDetail(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") source detail"
    case .showPlaybackLinks(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") alternative links"
    case .gettingPlaybackLinks(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Hiding") playback links spinner"
    case .gettingSearchResults(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") search spinner"
    case .shareLinkError(let error):
      return "\(type(of: self)): \(error ? "Setting a" : "Clearing any") share link error"
    case .showLoadRecommendationsAlert(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") load recommendations alert"
    case .setCollectionViewHeight(let height):
      return "\(type(of: self)): Setting collection view height to \(height)"
    case .setLibraryViewHeight(let height):
      return "\(type(of: self)): Setting library view height to \(height)"
    case .reset:
      return "\(type(of: self)): Resetting navigation to defaults"
    case .toggleDebug:
      return "\(type(of: self)): Toggling debug"
    }
  }
}
