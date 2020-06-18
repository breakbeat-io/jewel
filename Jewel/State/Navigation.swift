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
  
  var showCollectionLibraryOptions: Bool = false
  var collectionLibraryIsEditing: Bool = false
  var collectionLibraryEditSelection = Set<UUID>()
}
