//
//  Navigation.swift
//  Listen Later
//
//  Created by Greg Hepworth on 18/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct Navigation {

  var selectedTab: Navigation.Tab = .onrotation {
    didSet {
      stopEditing()
    }
  }
  enum Tab: String {
    case onrotation = "On Rotation"
    case library = "Collection Library"
  }
  
  var showOptions: Bool = false
  var showSettings: Bool = false
  
  var collectionIsEditing: Bool = false
  var collectionEditSelection = Set<Int>()
  
  var libraryIsEditing: Bool = false
  var libraryEditSelection = Set<UUID>()
  
  mutating func stopEditing() {
    collectionIsEditing = false
    libraryIsEditing = false
  }
  
}


