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
  case firstTimeRun(_: Bool)
  case reset
}

enum LibraryAction: AppAction {
  case userCollectionActive(_: Bool)
  case changeUserCollectionName(name: String)
  case changeUserCollectionCurator(curator: String)
  case addAlbumToSlot(album: Album, slotIndex: Int, collectionId: UUID)
  case removeAlbumFromSlot(slotIndexes: IndexSet)
  case setPlatformLinks(baseUrl: URL, platformLinks: OdesliResponse, collectionId: UUID)
  case moveSlot(from: IndexSet, to: Int)
  case invalidateShareLinks
  case setShareLinks(shareLinkLong: URL, shareLinkShort: URL)
  case shareLinkError(_: Bool)
  case addSharedCollection(collection: Collection)
  case removeSharedCollection(slotIndexes: IndexSet)
  case moveSharedCollection(from: IndexSet, to: Int)
  case cueSharedCollection(shareableCollection: ShareLinkProvider.ShareableCollection)
  case uncueSharedCollection
}

enum SearchAction: AppAction {
  case populateSearchResults(results: [Album])
  case removeSearchResults
}
