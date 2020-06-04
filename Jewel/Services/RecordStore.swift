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
  
    static func purchase(albumId: String) {
      RecordStore.appleMusic.album(id: albumId, completion: {
          (album: Album?, error: Error?) -> Void in
          DispatchQueue.main.async {
              if album != nil {
                  store.update(action: CollectionAction.addAlbumToSlot(album: album!))
                  store.update(action: CollectionAction.fetchAndSetPlatformLinks)
              }
          }
      })
    }
}
