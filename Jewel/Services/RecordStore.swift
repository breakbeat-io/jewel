//
//  Store.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

class RecordStore {
  static let appleMusic = HMV(storefront: .unitedKingdom, developerToken: Bundle.main.infoDictionary?["APPLE_MUSIC_API_TOKEN"] as! String)
  
  private init() { }
  
  static func browse(for searchTerm: String) {
    RecordStore.appleMusic.search(term: searchTerm, limit: 20, types: [.albums]) { results, error in
      if let results = results {
        DispatchQueue.main.async {
          store.update(action: SearchAction.populateSearchResults(results: (results.albums?.data)!))
        }
      }
      
      if let error = error {
        print(error.localizedDescription)
        // TODO: create another action to show an error in search results.
      }
    }
  }
  
  static func purchase(albumId: String) {
    RecordStore.appleMusic.album(id: albumId, completion: { album, error in
      if let album = album {
        DispatchQueue.main.async {
          store.update(action: CollectionAction.addAlbumToSlot(album: album))
          store.update(action: CollectionAction.fetchAndSetPlatformLinks)
        }
        
        if let error = error {
          print(error.localizedDescription)
          // TODO: create another action to show an error in album add.
        }
      }
    })
  }
}
