//
//  AppState.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct AppState {
    var collection: CollectionState
    var search: SearchState
}

struct CollectionState {
    var albums: [Album]
}

struct SearchState {
    var results: String?
}
