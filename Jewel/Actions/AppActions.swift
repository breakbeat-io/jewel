//
//  Actions.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

protocol AppAction {
  var description: String { get }
}

enum OptionsAction: AppAction {
  case setPreferredPlatform(platform: Int)
  case toggleDebugMode
  case firstTimeRun(_: Bool)
  case reset
  
  var description: String {
    switch self {
    case .setPreferredPlatform:
      return "\(type(of: self)): Setting preferred platform"
    case .toggleDebugMode:
      return "\(type(of: self)): Toggling debug mode"
    case .firstTimeRun:
      return "\(type(of: self)): Setting first time run"
    case .reset:
      return "\(type(of: self)): Performing reset"
    }
  }
}

enum LibraryAction: AppAction {
  case userCollectionActive(_: Bool)
  case setUserCollectionName(name: String)
  case setUserCollectionCurator(curator: String)
  case addAlbumToSlot(album: Album, slotIndex: Int, collectionId: UUID)
  case removeAlbumFromSlot(slotIndexes: IndexSet)
  case setPlatformLinks(baseUrl: URL, platformLinks: OdesliResponse, collectionId: UUID)
  case moveSlot(from: IndexSet, to: Int)
  case invalidateShareLinks
  case setShareLinks(shareLinkLong: URL, shareLinkShort: URL)
  case shareLinkError(_: Bool)
  case saveOnRotation(collection: Collection)
  case addSharedCollection(collection: Collection)
  case removeSharedCollection(slotIndexes: IndexSet)
  case moveSharedCollection(from: IndexSet, to: Int)
  case cueSharedCollection(shareableCollection: SharedCollectionManager.ShareableCollection)
  case uncueSharedCollection
  
  var description: String {
    switch self {
      
    case .userCollectionActive:
      return "\(type(of: self)): Setting user collection active state"
    case .setUserCollectionName:
      return "\(type(of: self)): Setting user collection name"
    case .setUserCollectionCurator:
      return "\(type(of: self)): Setting user collection curator"
    case .addAlbumToSlot:
      return "\(type(of: self)): Adding an album to a collection"
    case .removeAlbumFromSlot:
      return "\(type(of: self)): Removing an album from a collection"
    case .setPlatformLinks:
      return "\(type(of: self)): Setting platform links for an album"
    case .moveSlot:
      return "\(type(of: self)): Moving an albums slot"
    case .invalidateShareLinks:
      return "\(type(of: self)): Invalidating share links"
    case .setShareLinks:
      return "\(type(of: self)): Setting share links"
    case .shareLinkError:
      return "\(type(of: self)): Setting the share link error"
    case .saveOnRotation:
      return "\(type(of: self)): Saving current On Rotation to Library"
    case .addSharedCollection:
      return "\(type(of: self)): Adding a shared collection to the library"
    case .removeSharedCollection:
      return "\(type(of: self)): Removing a shared collection from the library"
    case .moveSharedCollection:
      return "\(type(of: self)): Moving a shared collections position"
    case .cueSharedCollection:
      return "\(type(of: self)): Cueing a shared collection"
    case .uncueSharedCollection:
      return "\(type(of: self)): Uncueing a shared collection"
      
    }
  }
}

enum SearchAction: AppAction {
  case populateSearchResults(results: [Album])
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
