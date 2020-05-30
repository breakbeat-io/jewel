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

enum CollectionActions: AppAction {
    case addAlbum(album: Album)
    case removeAlbum(at: IndexSet)
}

enum SearchActions: AppAction {
    case search(term: String)
    case populateSearchResults(results: [Album])
    case removeSearchResults
}
