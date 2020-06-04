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
  case changeCollectionName(name: String)
  case changeCollectionCurator(curator: String)
  case setSelectedSlot(slotIndex: Int)
  case deselectSlot
  case addAlbumToSlot(album: Album)
  case setPlatformLinks(baseUrl: URL, platformLinks: OdesliResponse)
  case removeAlbumFromSlot(slotIndexes: IndexSet)
  case moveSlot(from: IndexSet, to: Int)
}

enum SearchAction: AppAction {
  case populateSearchResults(results: [Album])
  case removeSearchResults
}
