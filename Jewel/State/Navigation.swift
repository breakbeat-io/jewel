//
//  Navigation.swift
//  Listen Later
//
//  Created by Greg Hepworth on 18/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct Navigation {
  var selectedTab: String = "onrotation"
  
  var showCollectionOptions: Bool = false
  var collectionIsEditing: Bool = false
  var collectionEditSelection = Set<Int>()
  
  var showLibraryOptions: Bool = false
  var libraryIsEditing: Bool = false
  var libraryEditSelection = Set<UUID>()
}
