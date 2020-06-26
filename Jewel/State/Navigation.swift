//
//  Navigation.swift
//  Listen Later
//
//  Created by Greg Hepworth on 18/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct Navigation {
  
  let onRotationId: UUID
  var activeCollectionId: UUID
  
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
  
  var showSourceDetail: Bool = false
  var showCollection: Bool = false
  
  var showLibraryOptions: Bool = false
  var libraryIsEditing: Bool = false
  var libraryEditSelection = Set<UUID>()
  
  var showCollectionOptions: Bool = false  
  var collectionIsEditing: Bool = false
  var collectionEditSelection = Set<Int>()
  
  var showSettings: Bool = false
  var showDebugMenu: Bool = false
  
}


