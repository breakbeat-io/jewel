//
//  AppStateV1.swift
//  Listen Later
//
//  Created by Greg Hepworth on 02/11/2021.
//  Copyright © 2021 Breakbeat Ltd. All rights reserved.
//

import Foundation
import MusicKit

struct AppStateV1: Codable {
  
  var navigation = Navigation()
  
  var settings: Settings
  var library: LibraryV1
  var search = Search()
  
  enum CodingKeys: String, CodingKey {
    case settings = "options"
    case library
  }
}

struct LibraryV1: Codable {
  
  var onRotation: CollectionV1
  
  var collections: [CollectionV1]
  var cuedCollection: SharedCollectionManager.ShareableCollection?
  
  enum CodingKeys: CodingKey {
    case onRotation
    case collections
  }
}

struct CollectionV1: Identifiable, Codable {
  var id = UUID()
  var type: CollectionType
  var name: String
  var curator: String
  var slots: [SlotV1] = {
    var tmpSlots = [SlotV1]()
    for _ in 0..<8 {
      let slot = SlotV1()
      tmpSlots.append(slot)
    }
    return tmpSlots
  }()
  
  var shareLinkLong: URL?
  var shareLinkShort: URL?
  
  enum CodingKeys: CodingKey {
    case id
    case name
    case type
    case curator
    case slots
    case shareLinkLong
    case shareLinkShort
  }
}

struct SlotV1: Identifiable, Codable {
  var id = UUID()
  var source: Album?
  var playbackLinks: OdesliResponse?
}
