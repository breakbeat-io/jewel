//
//  Slot.swift
//  Listen Later
//
//  Created by Greg Hepworth on 02/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

struct Slot: Identifiable, Codable {
  var id = UUID()
  var source: AppleMusicAlbum?
  var playbackLinks: OdesliResponse?
}

typealias AppleMusicAlbum = Album
