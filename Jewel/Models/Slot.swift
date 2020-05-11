//
//  Slot.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import Foundation
import HMV

struct Slot: Identifiable, Codable {
    let id: Int
    var album: Album?
}
