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
    let provider = SourceProvider.appleMusicAlbum
    var contentId: String
    var content: Album?
    
    init(contentId: String) {
        self.contentId = contentId
    }
    
    init(contentId: String, content: Album) {
        self.contentId = contentId
        self.content = content
    }
    
}
