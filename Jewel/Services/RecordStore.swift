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
  case NotFound(MusicItemID)
}

class RecordStore {
  
  static func search(for searchTerm: String) async throws -> MusicItemCollection<Album> {
    os_log("💎 Record Store > Searching for '\(searchTerm)'")
    do {
      var searchRequest = MusicCatalogSearchRequest(term: searchTerm, types: [Album.self])
      searchRequest.limit = 20
      return try await searchRequest.response().albums
    } catch {
      os_log("💎 Record Store > Search error: %s", String(describing: error))
      throw error
    }
  }
  
  static func getAlbum(withId appleMusicAlbumId: MusicItemID) async throws -> Source {
    os_log("💎 Record Store > Getting Album with ID \(appleMusicAlbumId.rawValue)")
    do {
      let resourceRequest = MusicCatalogResourceRequest<Album>(matching: \.id, equalTo: appleMusicAlbumId)
      let resourceResponse = try await resourceRequest.response()
      
      guard let album = resourceResponse.items.first else {
        os_log("💎 Record Store > Get album error: Unable to find Album with ID \(appleMusicAlbumId)")
        throw RecordStoreError.NotFound(appleMusicAlbumId)
      }
      
      return Source(album: album)
      
    } catch {
      os_log("💎 Record Store > Get album error: %s", String(describing: error))
      throw error
    }
  }
  
  static func getSongs(for album: Album) async throws -> [Song] {
    os_log("💎 Record Store > Getting Songs for \(album.id) '\(album.title)'")
    do {
      var songs = [Song]()
      let detailedAlbum = try await album.with([.tracks])
      
      if let tracks = detailedAlbum.tracks {
        // iterate through the tracks instead of spawning a taskgroup as that was causing a rate limit
        for track in tracks {
          let resourceRequest = MusicCatalogResourceRequest<Song>(matching: \.id, equalTo: track.id)
          async let resourceResponse = resourceRequest.response()
          guard let song = try await resourceResponse.items.first else { break }
          songs.append(song)
        }
      }
      
      return songs.sorted{ $0.trackNumber ?? 0 < $1.trackNumber ?? 0}
      
    } catch {
      os_log("💎 Record Store > Getting Songs error: %s", String(describing: error))
      throw error
    }
  }
  
  static func getPlaybackLinks(for baseUrl: URL) async throws -> OdesliResponse {
    os_log("💎 Playback Links > Populating links for %s", baseUrl.absoluteString)
    do {
      let (data, response) = try await URLSession.shared.data(from: URL(string: "https://api.song.link/v1-alpha.1/links?url=\(baseUrl.absoluteString)")!) as! (Data, HTTPURLResponse)
      
      if response.statusCode != 200 {
        os_log("💎 Playback Links > Unexpected URL response code: %s", response.statusCode)
      }
      
      let playbackLinks = try JSONDecoder().decode(OdesliResponse.self, from: data)
      return playbackLinks
      
    } catch {
      os_log("💎 Playback Links > Error getting playbackLinks: %s", error.localizedDescription)
      throw error
    }
  }
}
