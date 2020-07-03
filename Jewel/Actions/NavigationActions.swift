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
    
  case let .editCollection(editCollectionState):
    newNavigation.collectionIsEditing = editCollectionState
  
  case let .showCollectionOptions(showCollectionOptionsState):
    newNavigation.showCollectionOptions = showCollectionOptionsState
    
  case let .setCollectionEditSelection(editSelection):
    newNavigation.collectionEditSelection = editSelection
  
  case .clearCollectionEditSelection:
    newNavigation.collectionEditSelection.removeAll()
    
  case let .editLibrary(editLibraryState):
    newNavigation.libraryIsEditing = editLibraryState
  
  case let .showLibraryOptions(showLibraryOptionsState):
    newNavigation.showLibraryOptions = showLibraryOptionsState
    
  case let .setLibraryEditSelection(editSelection):
    newNavigation.libraryEditSelection = editSelection
  
  case .clearLibraryEditSelection:
    newNavigation.libraryEditSelection.removeAll()
    
  case let .showSourceDetail(showSourceDetailState):
    newNavigation.showSourceDetail = showSourceDetailState
  
  case let .showAlternativeLinks(showAlternativeLinksState):
    newNavigation.showAlternativeLinks = showAlternativeLinksState
  
  case let .shareLinkError(shareLinkErrorState):
    newNavigation.shareLinkError = shareLinkErrorState
    
  case let .showLoadRecommendationsAlert(loadRecommendationsAlertState):
    newNavigation.showLoadRecommendationsAlert = loadRecommendationsAlertState
    
  case let .setDetailViewHeight(viewHeight):
    newNavigation.detailViewHeight = viewHeight
  
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
  case showSettings(_: Bool)
  case showSearch(_: Bool)
  case showSharing(_: Bool)
  case showCollection(_: Bool)
  case editCollection(_: Bool)
  case showCollectionOptions(_: Bool)
  case setCollectionEditSelection(editSelection: Set<Int>)
  case clearCollectionEditSelection
  case editLibrary(_: Bool)
  case showLibraryOptions(_: Bool)
  case setLibraryEditSelection(editSelection: Set<UUID>)
  case clearLibraryEditSelection
  case showSourceDetail(_: Bool)
  case showAlternativeLinks(_: Bool)
  case shareLinkError(_: Bool)
  case showLoadRecommendationsAlert(_: Bool)
  case setDetailViewHeight(viewHeight: CGFloat)
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
    case .editCollection(let editing):
      return "\(type(of: self)): \(editing ? "Editing" : "Finished editing") collection"
    case .showCollectionOptions(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") collection options"
    case .setCollectionEditSelection:
      return "\(type(of: self)): Setting collection edit selection"
    case .clearCollectionEditSelection:
      return "\(type(of: self)): Clearing collection edit selection"
    case .editLibrary(let editing):
      return "\(type(of: self)): \(editing ? "Editing" : "Finished editing") library"
    case .showLibraryOptions(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") library options"
    case .setLibraryEditSelection:
      return "\(type(of: self)): Setting library edit selection"
    case .clearLibraryEditSelection:
      return "\(type(of: self)): Clearing library edit selection"
    case .showSourceDetail(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") source detail"
    case .showAlternativeLinks(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") alternative links"
    case .shareLinkError(let error):
      return "\(type(of: self)): \(error ? "Setting a" : "Clearing any") share link error"
    case .showLoadRecommendationsAlert(let showing):
      return "\(type(of: self)): \(showing ? "Showing" : "Closing") load recommendations alert"
    case .setDetailViewHeight(let height):
      return "\(type(of: self)): Setting view height to \(height)"
    case .reset:
      return "\(type(of: self)): Resetting navigation to defaults"
    case .toggleDebug:
      return "\(type(of: self)): Toggling debug"
    }
  }
}
