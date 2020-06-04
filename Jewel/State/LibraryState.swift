//
//  LibraryState.swift
//  Listen Later
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

struct LibraryState: Codable {
  var collections = [CollectionState]()
}
