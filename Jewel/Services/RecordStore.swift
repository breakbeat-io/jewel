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
          if let results = results.albums?.data {
            store.update(action: SearchAction.populateSearchResults(results: results))
          }
        }
      }
      
      if let error = error {
        print(error.localizedDescription)
        // TODO: create another action to show an error in search results.
      }
    }
  }
  
  static func purchase(albumId: String, slotIndex: Int) {
    RecordStore.appleMusic.album(id: albumId, completion: { album, error in
      if let album = album {
        DispatchQueue.main.async {
          store.update(action: CollectionAction.addAlbumToSlot(album: album, slotIndex: slotIndex))
          if let baseUrl = album.attributes?.url {
            RecordStore.alternativeSuppliers(for: baseUrl)
          }
        }
        
        if let error = error {
          print(error.localizedDescription)
          // TODO: create another action to show an error in album add.
        }
      }
    })
  }
  
  static func borrow(albumId: String, slotIndex: Int, collectionId: UUID) {
    RecordStore.appleMusic.album(id: albumId, completion: { album, error in
      if let album = album {
        DispatchQueue.main.async {
          store.update(action: LibraryAction.addAlbumToSlot(album: album, slotIndex: slotIndex, collectionId: collectionId))
//          if let baseUrl = album.attributes?.url {
//            RecordStore.alternativeSuppliers(for: baseUrl)
//          }
        }
        
        if let error = error {
          print(error.localizedDescription)
          // TODO: create another action to show an error in album add.
        }
      }
    })
  }
  
  
  static func alternativeSuppliers(for baseUrl: URL) {
    print("Platform Links: Populating links for \(baseUrl.absoluteString)")
    
    let request = URLRequest(url: URL(string: "https://api.song.link/v1-alpha.1/links?url=\(baseUrl.absoluteString)")!)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let response = response as? HTTPURLResponse {
        if response.statusCode != 200 {
          print(response.statusCode)
        }
      }
      
      if let data = data {
        if let decodedResponse = try? JSONDecoder().decode(OdesliResponse.self, from: data) {
          DispatchQueue.main.async {
            store.update(action: CollectionAction.setPlatformLinks(baseUrl: baseUrl, platformLinks: decodedResponse))
          }
          
          return
        }
      }
      
      if let error = error {
        print("Platform Links: Error getting playbackLinks: \(error.localizedDescription)")
      }
      
    }.resume()
  }
}
