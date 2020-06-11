//
//  Helpers.swift
//  Listen Later
//
//  Created by Greg Hepworth on 11/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import UIKit

struct Helpers {
  
  static func cardHeight(viewHeight: CGFloat) -> CGFloat {
    switch viewHeight {
    case 852...:
      return 94
    case 673..<852:
      return 71
    default:
      return 61
    }
  }
  
}
