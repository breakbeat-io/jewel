//
//  Navigation.swift
//  Listen Later
//
//  Created by Greg Hepworth on 18/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct Navigation {
  
  var showDebugMenu: Bool = false

  var selectedTab: Navigation.Tab = .onrotation {
    didSet {
      listIsEditing = false
      selectedCollection = nil
    }
  }
  enum Tab: String {
    case onrotation = "On Rotation"
    case library = "Collection Library"
  }
  
  var showSourceDetail: Bool = false
  
  var showHomeOptions: Bool = false
  var showSettings: Bool = false
  var showCollectionOptions: Bool = false
  
  var listIsEditing: Bool = false
  var collectionEditSelection = Set<Int>()
  var libraryEditSelection = Set<UUID>()
  
  var selectedCollection: UUID?
  
}


