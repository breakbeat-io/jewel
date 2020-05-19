//
//  Source.swift
//  Jewel
//
//  Created by Greg Hepworth on 13/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

class Source: Codable {
    let sourceProvider = SourceProvider.appleMusicAlbum
    var sourceReference: String
    var content: Album?
    
    init(sourceReference: String) {
        self.sourceReference = sourceReference
    }
    
    init(sourceReference: String, album: Album) {
        self.sourceReference = sourceReference
        self.content = album
    }
    
}
