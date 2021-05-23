//
//  Store.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import os.log
import HMV

class RecordStore {
  static let appleMusic = HMV(storefront: .unitedKingdom, developerToken: Secrets.appleMusicAPIToken)
  
  private init() { }
  
  static func browse(for searchTerm: String) {
    RecordStore.appleMusic.search(term: searchTerm, limit: 20, types: [.albums]) { results, error in
      if let results = results {
        DispatchQueue.main.async {
          if let results = results.albums?.data {
            AppEnvironment.global.update(action: SearchAction.populateSearchResults(results: results))
          }
        }
      }
      
      if let error = error {
        os_log("💎 Record Store > Browse error: %s", String(describing: error))
        // TODO: create another action to show an error in search results.
      }
    }
  }
  
  static func purchase(album appleMusicAlbumId: String, forSlot slotIndex: Int, inCollection collectionId: UUID) {
    RecordStore.appleMusic.album(id: appleMusicAlbumId, completion: { appleMusicAlbum, error in
      if let album = appleMusicAlbum {
        DispatchQueue.main.async {
          AppEnvironment.global.update(action: LibraryAction.addSourceToSlot(source: album, slotIndex: slotIndex, collectionId: collectionId))
          if let baseUrl = album.attributes?.url {
            RecordStore.alternativeSuppliers(for: baseUrl, inCollection: collectionId)
          }
        }
      }
      
      if let error = error {
        os_log("💎 Record Store > Purchase error: %s", String(describing: error))
        // TODO: create another action to show an error in album add.
      }
      
    })
  }
  
  static func alternativeSuppliers(for baseUrl: URL, inCollection collectionId: UUID) {
    os_log("💎 Platform Links > Populating links for %s", baseUrl.absoluteString)
    
    let request = URLRequest(url: URL(string: "https://api.song.link/v1-alpha.1/links?url=\(baseUrl.absoluteString)")!)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
      if let response = response as? HTTPURLResponse {
        if response.statusCode != 200 {
          os_log("💎 Platform Links > Unexepcted URL response code: %s", response.statusCode)
        }
      }
      
      if let data = data {
        if let decodedResponse = try? JSONDecoder().decode(OdesliResponse.self, from: data) {
          DispatchQueue.main.async {
            AppEnvironment.global.update(action: LibraryAction.setPlatformLinks(baseUrl: baseUrl, platformLinks: decodedResponse, collectionId: collectionId))
          }
          
          return
        }
      }
      
      if let error = error {
        os_log("💎 Platform Links > Error getting playbackLinks: %s", error.localizedDescription)
      }
      
    }.resume()
  }
}
