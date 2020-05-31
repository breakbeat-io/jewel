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

enum CollectionAction: AppAction {
    case changeCollectionName(name: String)
    case changeCollectionCurator(curator: String)
    case fetchAndAddAlbum(albumId: String)
    case addAlbum(album: Album)
    case removeAlbum(at: IndexSet)
}

enum SearchAction: AppAction {
    case search(term: String)
    case populateSearchResults(results: [Album])
    case removeSearchResults
}
