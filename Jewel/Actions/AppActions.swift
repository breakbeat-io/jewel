//
//  Actions.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

protocol AppAction { }

enum OptionsAction: AppAction {
  case setPreferredPlatform(platform: Int)
  case toggleDebugMode
  case reset
}

enum CollectionAction: AppAction {
  case toggleActive
  case setActiveState(activeState: Bool)
  case changeCollectionName(name: String)
  case changeCollectionCurator(curator: String)
  case addAlbumToSlot(album: Album, slotIndex: Int)
  case setPlatformLinks(baseUrl: URL, platformLinks: OdesliResponse)
  case removeAlbumFromSlot(slotIndexes: IndexSet)
  case moveSlot(from: IndexSet, to: Int)
  case invalidateShareLinks
  case setShareLinks(shareLinkLong: URL, shareLinkShort: URL)
  case setShareLinkError(errorState: Bool)
}

enum LibraryAction: AppAction {
  case addCollection(collection: Collection)
  case removeCollection(slotIndexes: IndexSet)
  case moveCollection(from: IndexSet, to: Int)
  case cueRecievedCollection(collection: Collection)
  case uncueRecievedCollection
  case setRecievedCollectioCued(cuedState: Bool)
  case commitRecievedCollection
}

enum SearchAction: AppAction {
  case populateSearchResults(results: [Album])
  case removeSearchResults
}
