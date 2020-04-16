//
//  Release+Image.swift
//  Jewel
//
//  Created by Greg Hepworth on 16/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import HMV

extension Release {
    var artwork: Image {
        ImageStore.shared.image(name: artworkFileName)
    }
}
