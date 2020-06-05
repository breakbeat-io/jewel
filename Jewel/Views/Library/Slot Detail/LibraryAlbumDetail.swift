//
//  LibraryAlbumDetail.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct LibraryAlbumDetail: View {
  
  var slot: Slot
  
  var body: some View {
    ScrollView {
      VStack {
        IfLet(slot.album?.attributes) { attributes in
          NewAlbumCover(albumName: attributes.name,
                        albumArtist: attributes.artistName,
                        albumArtwork: attributes.artwork.url(forWidth: 1000))
          LibraryPlaybackLinks(slot: self.slot)
            .padding(.bottom)
          TrackList(tracks: (self.slot.album?.relationships?.tracks.data)!, albumArtist: attributes.artistName)
        }
      }
      .padding()
    }
  }
}
