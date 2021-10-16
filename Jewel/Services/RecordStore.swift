//
//  Store.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import os.log
import MusicKit

enum RecordStoreError: Error {
  case searchError(String)
  case purchaseError(String)
}

class RecordStore {
  
  static func search(for searchTerm: String) async {
    do {
      var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Album.self])
      searchRequest.limit = 20
      
      let searchResponse = try await searchRequest.response()
      
      await AppEnvironment.global.update(action: SearchAction.populateSearchResults(results: searchResponse.albums))
    } catch {
      os_log("💎 Record Store > Browse error: %s", String(describing: error))
    }
  }
  
  static func purchase(album appleMusicAlbumId: String, forSlot slotIndex: Int, inCollection collectionId: UUID) async {
    do {
      let resourceRequest = MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: MusicItemID(rawValue: appleMusicAlbumId))
      let resourceResponse = try await resourceRequest.response()
      
      guard let album = resourceResponse.items.first else {
        throw RecordStoreError.purchaseError("Unable to find Album with ID \(appleMusicAlbumId)")
      }
      
      await AppEnvironment.global.update(action: LibraryAction.addSourceToSlot(source: album, slotIndex: slotIndex, collectionId: collectionId))
      if let baseUrl = album.url {
        RecordStore.alternativeSuppliers(for: baseUrl, inCollection: collectionId)
      }
      
    } catch {
      os_log("💎 Record Store > Purchase error: %s", String(describing: error))
    }
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
