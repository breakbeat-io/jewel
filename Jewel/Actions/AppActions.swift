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
    case fetchAndAddAlbum(albumId: String)
    case addAlbum(album: Album)
    case removeAlbum(slotIndexes: IndexSet)
    case moveAlbum(from: IndexSet, to: Int)
}

enum SearchAction: AppAction {
    case search(for: String)
    case populateSearchResults(results: [Album])
    case removeSearchResults
}
