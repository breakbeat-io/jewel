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
      
      let source = FullAppleAlbum(album: album)
      
      await AppEnvironment.global.update(action: LibraryAction.addSourceToSlot(source: source, slotIndex: slotIndex, collectionId: collectionId))
      
      RecordStore.getSongs(album: album, inCollection: collectionId)
      
      if let baseUrl = album.url {
        RecordStore.alternativeSuppliers(for: baseUrl, inCollection: collectionId)
      }
      
    } catch {
      os_log("💎 Record Store > Purchase error: %s", String(describing: error))
    }
  }
  
  static func getSongs(album: Album, inCollection collectionId: UUID) {
    Task {
      do {
        let detailedAlbum = try await album.with([.tracks])
        if let tracks = detailedAlbum.tracks {
          var songs = [Song]()
          
          songs = try await withThrowingTaskGroup(of: Song?.self) { taskGroup in
            var songResults = [Song]()
            for track in tracks {
              taskGroup.addTask {
                let resourceRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: track.id)
                let resourceResponse = try await resourceRequest.response()
                return resourceResponse.items.first
              }
            }
            
            for try await song in taskGroup {
              guard let song = song else { break }
              songResults.append(song)
            }
            
            return songResults.sorted{ $0.trackNumber ?? 0 < $1.trackNumber ?? 0}
          }
          
          await AppEnvironment.global.update(action: LibraryAction.addSongsToAlbum(albumId: album.id, songs: songs, collectionId: collectionId))
        }
        
      } catch {
        os_log("💎 Record Store > Song error: %s", String(describing: error))
      }
    }
  }
  
  static func alternativeSuppliers(for baseUrl: URL, inCollection collectionId: UUID) {
    os_log("💎 Platform Links > Populating links for %s", baseUrl.absoluteString)
    
    Task {
      do {
        let (data, response) = try await URLSession.shared.data(from: URL(string: "https://api.song.link/v1-alpha.1/links?url=\(baseUrl.absoluteString)")!) as! (Data, HTTPURLResponse)
        
        if response.statusCode != 200 {
          os_log("💎 Platform Links > Unexepcted URL response code: %s", response.statusCode)
        }
        
        if let decodedResponse = try? JSONDecoder().decode(OdesliResponse.self, from: data) {
          await AppEnvironment.global.update(action: LibraryAction.setPlatformLinks(baseUrl: baseUrl, platformLinks: decodedResponse, collectionId: collectionId))
          return
        }
        
      } catch {
        os_log("💎 Platform Links > Error getting playbackLinks: %s", error.localizedDescription)
      }
    }
  }
}
