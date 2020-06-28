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
  
  static let regularMaxWidth: CGFloat = 600
  
  static let buttonWidth: CGFloat = 80
  static let optionsButtonIconWidth: CGFloat = 30
  static let cardCornerRadius: CGFloat = 4
  
  enum cardHeights: CGFloat {
    case extraTall = 130
    case tall = 94
    case medium = 71
    case short = 61
  }
  
  static func cardHeightFor(viewHeight: CGFloat) -> CGFloat {
    switch viewHeight {
    case 1098...:
      return cardHeights.extraTall.rawValue
    case 852...:
      return cardHeights.tall.rawValue
    case 696...:
      return cardHeights.medium.rawValue
    default:
      return cardHeights.short.rawValue
    }
  }
  
}
