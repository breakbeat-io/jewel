//
//  JewelPreferences.swift
//  Jewel
//
//  Created by Greg Hepworth on 11/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct Preferences: Codable {
    
    var preferredMusicPlatform: Int
    var curatorName: String
    var debugMode = false
    
    static let `default` = Self(preferredMusicPlatform: 0, curatorName: "A Music Lover")
    
}
