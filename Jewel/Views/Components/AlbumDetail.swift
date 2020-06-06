//
//  AlbumView.swift
//  Listen Later
//
//  Created by Greg Hepworth on 06/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct AlbumDetail: View {
  
  let slot: Slot
  
  var body: some View {
    ScrollView {
      VStack {
        IfLet(slot.album?.attributes) { attributes in
          AlbumCover(albumName: attributes.name,
                     albumArtist: attributes.artistName,
                     albumArtwork: attributes.artwork.url(forWidth: 1000))
          PlaybackLinks(baseUrl: attributes.url,
                        playbackLinks: self.slot.playbackLinks)
            .padding(.bottom)
          IfLet(self.slot.album?.relationships?.tracks.data) { tracks in
            TrackList(tracks: tracks,
                      albumArtist: attributes.artistName
            )
          }
        }
      }
      .padding()
    }
  }
}
