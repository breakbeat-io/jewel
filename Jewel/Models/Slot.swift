//
//  Slot.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import Foundation

struct Slot<T: Source>: Identifiable, Codable {
    var id = UUID()
    var source: T?
    var playbackLinks: OdesliResponse?
}
