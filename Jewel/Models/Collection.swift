//
//  Collection.swift
//  Jewel
//
//  Created by Greg Hepworth on 13/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

class Collection: Codable {
    var name: String
    var curator = "A Music Lover"
    var slots = [Slot](repeating: Slot(), count: 8)
    var editable: Bool
    
    init(name: String, editable: Bool) {
        self.name = name
        self.editable = editable
    }
}
