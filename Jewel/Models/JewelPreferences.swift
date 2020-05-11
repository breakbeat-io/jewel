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
    var collectionName = ""
    var debugMode = false
}
