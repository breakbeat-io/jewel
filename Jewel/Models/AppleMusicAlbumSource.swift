//
//  Source.swift
//  Jewel
//
//  Created by Greg Hepworth on 13/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

struct AppleMusicAlbumSource: Codable {
    let sourceProvider = SourceProvider.appleMusicAlbum
    let sourceReference: String
    var album: Album?
}
