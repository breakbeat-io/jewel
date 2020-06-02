//
//  CollectionState.swift
//  Jewel
//
//  Created by Greg Hepworth on 01/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

struct CollectionState: Codable {
    var name: String = "My Collection"
    var curator: String = "A Music Lover"
    var slots = [Album?](repeating: nil, count: 8)
    var selectedSlot: Int?
}
