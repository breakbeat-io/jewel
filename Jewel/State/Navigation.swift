//
//  Navigation.swift
//  Listen Later
//
//  Created by Greg Hepworth on 18/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import SwiftUI

struct Navigation {
  
  var onRotationId: UUID?
  var activeCollectionId: UUID?
  var activeSlotIndex: Int = 0
  
  var onRotationActive: Bool {
    onRotationId == activeCollectionId
  }
  
  var selectedTab: Navigation.Tab = .onRotation {
    didSet {
      collectionIsEditing = false
      libraryIsEditing = false
      activeCollectionId = onRotationId
    }
  }
  enum Tab: String {
    case onRotation = "On Rotation"
    case library = "Collection Library"
  }
  
  var showSearch: Bool = false
  var showSharing: Bool = false
  var showLoadRecommendationsAlert: Bool = false
  
  var showSourceDetail: Bool = false
  var showAlternativeLinks: Bool = false
  
  var showCollection: Bool = false
  
  var showLibraryOptions: Bool = false
  var libraryIsEditing: Bool = false
  var libraryEditSelection = Set<UUID>()
  
  var showCollectionOptions: Bool = false  
  var collectionIsEditing: Bool = false
  var collectionEditSelection = Set<Int>()
  
  var shareLinkError = false
  
  var showSettings: Bool = false
  var showDebugMenu: Bool = false
  
  var libraryViewHeight: CGFloat = 812
  var collectionCardHeight: CGFloat {
    let height = (self.libraryViewHeight - 200) / 8
    return height < 61 ? 61 : height
  }
  
  var collectionViewHeight: CGFloat = 812
  var albumCardHeight: CGFloat {
    let height = (self.collectionViewHeight - 200) / 8
    return height < 61 ? 61 : height
  }
  
}
