//
//  Collection.swift
//  Jewel
//
//  Created by Greg Hepworth on 13/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct Collection: Codable {
    let numberOfSlots = 8
    var name = "My Collection"
    var slots = [Slot]()
}