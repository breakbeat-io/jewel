//
//  Slot.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import Foundation

struct Slot: Identifiable, Codable {
    var id = UUID()
    var source: Source?
    var playbackLinks: OdesliResponse?
}
