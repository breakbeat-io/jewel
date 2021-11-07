//
//  SearchState.swift
//  Jewel
//
//  Created by Greg Hepworth on 01/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import MusicKit

struct Search: Codable {
  var results: MusicItemCollection<Album>?
}
