//
//  Store.swift
//  Jewel
//
//  Created by Greg Hepworth on 19/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

class Store {
    static let appleMusic = HMV(storefront: .unitedKingdom, developerToken: Bundle.main.infoDictionary?["APPLE_MUSIC_API_TOKEN"] as! String)
    
    private init() { }
}
