//
//  Slot.swift
//  Listen Later
//
//  Created by Greg Hepworth on 02/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import MusicKit

struct Slot: Identifiable, Codable {
  var id = UUID()
  var source: Album?
  var playbackLinks: OdesliResponse?
}
