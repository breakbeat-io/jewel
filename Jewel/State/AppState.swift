//
//  AppState.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct AppState: Codable {
  var options: OptionsState
  var collection: CollectionState
  var library: LibraryState
  var search: SearchState
}
