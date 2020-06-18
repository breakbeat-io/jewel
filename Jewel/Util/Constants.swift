//
//  Helpers.swift
//  Listen Later
//
//  Created by Greg Hepworth on 11/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
  
  static let optionsButtonIconWidth: CGFloat = 30
  
  enum cardHeights: CGFloat {
    case tall = 94
    case medium = 71
    case short = 61
  }
  
  static func cardHeightFor(viewHeight: CGFloat) -> CGFloat {
    switch viewHeight {
    case 852...:
      return cardHeights.tall.rawValue
    case 673..<852:
      return cardHeights.medium.rawValue
    default:
      return cardHeights.short.rawValue
    }
  }
  
}
