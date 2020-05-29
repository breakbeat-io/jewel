//
//  Actions.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

enum AppAction {
    case addAlbum(album: Album)
    case removeAlbum(at: IndexSet)
    case search(term: String)
    case removeSearchResults
}
