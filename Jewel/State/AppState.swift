//
//  AppState.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

struct AppState: Codable {
    var collection: CollectionState
    var search: SearchState
}

struct CollectionState: Codable {
    var name: String = "My Collection"
    var curator: String = "A Music Lover"
    var albums: [Album]
}

struct SearchState: Codable {
    var results: [Album]?
}
