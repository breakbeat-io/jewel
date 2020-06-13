//
//  LibraryState.swift
//  Listen Later
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

struct Library: Codable {
  
  var onRotation: Collection
  var onRotationActive: Bool = true
  
  var sharedCollections: [Collection]
  var cuedCollection: SharedCollectionManager.ShareableCollection?
  
  enum CodingKeys: CodingKey {
    case onRotation
    case sharedCollections
  }
}
