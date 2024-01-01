//
//  LibraryState.swift
//  Stacks
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct Library: Codable {
  
  var onRotation: Stack
  var stacks: [Stack]
  
  enum CodingKeys: CodingKey {
    case onRotation
    case stacks
  }
}
