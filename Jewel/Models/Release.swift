//
//  Release.swift
//  Jewel
//
//  Created by Greg Hepworth on 16/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct Release: Hashable, Codable, Identifiable {
    var id: Int
    var title: String
    var artist: String
    fileprivate var artworkFileName: String
    
}

extension Release {
    var artwork: Image {
        ImageStore.shared.image(name: artworkFileName)
    }
}
