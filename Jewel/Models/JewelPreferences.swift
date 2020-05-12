//
//  JewelPreferences.swift
//  Jewel
//
//  Created by Greg Hepworth on 11/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct JewelPreferences: Codable {
    let numberOfSlots = 8
    var collectionName = "My Collection"
    var primaryMusicProvider = 2 // Apple Music
    var debugMode = false
}
