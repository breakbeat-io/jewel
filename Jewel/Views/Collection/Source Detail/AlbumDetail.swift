//
//  AlbumDetail.swift
//  Jewel
//
//  Created by Greg Hepworth on 30/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct AlbumDetail: View {
  
  @EnvironmentObject var store: AppStore
  
  private var album: Album? {
    if let i = store.state.collection.selectedSlot {
      return store.state.collection.slots[i].album
    }
    return nil
  }
  
  private var tracks: [Track]? {
    album?.relationships?.tracks.data
  }
  private var albumArtist: String? {
    album?.attributes?.artistName
  }
  
  var body: some View {
    ScrollView {
      VStack {
        AlbumCover()
        PlaybackLinks()
          .padding(.bottom)
        IfLet(tracks) { tracks in
          IfLet(self.albumArtist) { albumArtist in
            NewTrackList(
              tracks: tracks,
              albumArtist: albumArtist
            )
          }
          
        }
      }
      .padding()
    }
    .onDisappear {
      self.store.update(action: CollectionAction.deselectSlot)
    }
  }
}
