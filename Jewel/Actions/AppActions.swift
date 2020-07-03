//
//  Actions.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import SwiftUI
import HMV

protocol AppAction {
  var description: String { get }
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

enum OptionsAction: AppAction {
  case firstTimeRun(_: Bool)
  case setPreferredPlatform(platform: Int)
  case reset
  
  var description: String {
    switch self {
    case .setPreferredPlatform(let platformId):
      return "\(type(of: self)): Setting preferred platform to ID: \(platformId)"
    case .firstTimeRun(let firstTime):
      return "\(type(of: self)): \(firstTime ? "Setting to" : "Clearing") first time run"
    case .reset:
      return "\(type(of: self)): Performing reset"
    }
  }
}

enum LibraryAction: AppAction {
  case setCollectionName(name: String, collectionId: UUID)
  case setCollectionCurator(curator: String, collectionId: UUID)
  case addSourceToSlot(source: AppleMusicAlbum, slotIndex: Int, collectionId: UUID)
  case removeSourceFromSlot(slotIndex: Int, collectionId: UUID)
  case removeSourcesFromCollection(slotIndexes: Set<Int>, collectionId: UUID)
  case setPlatformLinks(baseUrl: URL, platformLinks: OdesliResponse, collectionId: UUID)
  case moveSlot(from: Int, to: Int, collectionId: UUID)
  case invalidateShareLinks(collectionId: UUID)
  case setShareLinks(shareLinkLong: URL, shareLinkShort: URL, collectionId: UUID)
  case saveOnRotation(collection: Collection)
  case addUserCollection
  case addSharedCollection(collection: Collection)
  case removeSharedCollection(libraryIndex: Int)
  case removeSharedCollections(collectionIds: Set<UUID>)
  case moveSharedCollection(from: Int, to: Int)
  case cueSharedCollection(shareableCollection: SharedCollectionManager.ShareableCollection)
  case uncueSharedCollection
  
  var description: String {
    switch self {
      
    case .setCollectionName(let name, _):
      return "\(type(of: self)): Setting user collection name to \(name)"
      
    case .setCollectionCurator(let curator, _):
      return "\(type(of: self)): Setting user collection curator to \(curator)"
      
    case .addSourceToSlot(let source, let slotIndex, let collectionId):
      return "\(type(of: self)): Adding AppleMusicAlbum \(source.id) to slot \(slotIndex) in collection \(collectionId)"
      
    case .removeSourceFromSlot(let slotIndex, let collectionId):
      return "\(type(of: self)): Removing source in slot \(slotIndex) from collection \(collectionId)"
      
    case .removeSourcesFromCollection(let slotIndexes, let collectionId):
      return "\(type(of: self)): Removing sources in slots \(slotIndexes) from collection \(collectionId)"
      
    case .setPlatformLinks(let baseUrl, _, let collectionId):
      return "\(type(of: self)): Setting platform links for any source with \(baseUrl) in \(collectionId)"
      
    case .moveSlot(let slotIndex, let position, let collectionId):
      return "\(type(of: self)): Moving slot \(slotIndex) to position \(position) in \(collectionId)"
      
    case .invalidateShareLinks(let collectionId):
      return "\(type(of: self)): Invalidating share links for \(collectionId)"
      
    case .setShareLinks(_, _, let collectionId):
      return "\(type(of: self)): Setting share links for \(collectionId)"
      
    case .saveOnRotation:
      return "\(type(of: self)): Saving current On Rotation to Library"
      
    case .addUserCollection:
      return "\(type(of: self)): Creating a user collection in the Library"
      
    case .addSharedCollection:
      return "\(type(of: self)): Adding a shared collection to the library"
      
    case .removeSharedCollection(let libraryIndex):
      return "\(type(of: self)): Removing collection in position \(libraryIndex) from the Library"
      
    case .removeSharedCollections(let collectionIds):
      return "\(type(of: self)): Removing collections with IDs \(collectionIds) from the library"
      
    case .moveSharedCollection(let libraryIndex, let position):
      return "\(type(of: self)): Moving collection \(libraryIndex) to position \(position) in the Library"
      
    case .cueSharedCollection:
      return "\(type(of: self)): Cueing a shared collection"
      
    case .uncueSharedCollection:
      return "\(type(of: self)): Uncueing a shared collection"
      
    }
  }
}

enum SearchAction: AppAction {
  case populateSearchResults(results: [AppleMusicAlbum])
  case removeSearchResults
  
  var description: String {
    switch self {
    case .populateSearchResults:
      return "\(type(of: self)): Populating search results"
    case .removeSearchResults:
      return "\(type(of: self)): Removing search results"
    }
  }
}
