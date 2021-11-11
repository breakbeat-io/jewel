//
//  FullAppleAlbum.swift
//  Listen Later
//
//  Created by Greg Hepworth on 17/10/2021.
//  Copyright © 2021 Breakbeat Ltd. All rights reserved.
//

import Foundation
import MusicKit

struct Source: Codable {
  var album: Album
  var songs: [Song]?
}
