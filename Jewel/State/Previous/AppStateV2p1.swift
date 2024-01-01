//
//  AppStateV2p1.swift
//  Stacks
//
//  Created by Greg Hepworth on 01/01/2024.
//  Copyright © 2024 Breakbeat Ltd. All rights reserved.
//

import Foundation
import MusicKit

struct AppStateV2p1: Codable {
  
  var navigation = AppStateV2p1.Navigation()
  
  var settings: AppStateV2p1.Settings
  var library: AppStateV2p1.Library
  var search = Search()
  
  enum CodingKeys: String, CodingKey {
    case settings = "options"
    case library
  }
  
  struct Navigation {
    
    var onRotationId: UUID?
    var activeCollectionId: UUID?
    var activeSlotIndex: Int = 0
    
    var onRotationActive: Bool {
      onRotationId == activeCollectionId
    }
    
    var selectedTab: Navigation.Tab = .onRotation {
      didSet {
        activeCollectionId = onRotationId
      }
    }
    enum Tab: String {
      case onRotation = "On Rotation"
      case library = "Collections"
    }
    
    var showSearch: Bool = false
    
    var showAlbumDetail: Bool = false
    var showPlaybackLinks: Bool = false
    
    var gettingPlaybackLinks: Bool = false
    var gettingSearchResults: Bool = false
    
    var showCollection: Bool = false
    var showCollectionOptions: Bool = false
    
    var showLibraryOptions: Bool = false
    
    var showSettings: Bool = false
    var showDebugMenu: Bool = false
    
    var libraryViewHeight: CGFloat = 812
    var collectionCardHeight: CGFloat {
      cardHeightFor(libraryViewHeight)
    }
    
    var collectionViewHeight: CGFloat = 812
    var albumCardHeight: CGFloat {
      cardHeightFor(collectionViewHeight)
    }
    
    private func cardHeightFor(_ viewHeight: CGFloat) -> CGFloat {
      let height = (viewHeight - 200) / 8
      return height < 61 ? 61 : height
    }
    
  }
  
  struct Settings: Codable {
    var preferredMusicPlatform: OdesliPlatform = .appleMusic
    var firstTimeRun: Bool = true
  }
  
  struct Library: Codable {
    
    var onRotation: AppStateV2p1.Collection
    var collections: [AppStateV2p1.Collection]
    
    enum CodingKeys: CodingKey {
      case onRotation
      case collections
    }
  }
  
  struct Collection: Identifiable, Codable {
    var id = UUID()
    var name: String
    var slots: [AppStateV2p1.Slot] = {
      var tmpSlots = [AppStateV2p1.Slot]()
      for _ in 0..<8 {
        let slot = AppStateV2p1.Slot()
        tmpSlots.append(slot)
      }
      return tmpSlots
    }()
    
    enum CodingKeys: CodingKey {
      case id
      case name
      case slots
    }
  }
  
  struct Slot: Identifiable, Codable {
    var id = UUID()
    var album: Album?
    var playbackLinks: OdesliResponse?
    
    enum CodingKeys: String, CodingKey {
      case id
      case album = "source"
      case playbackLinks
    }
  }
  
}
