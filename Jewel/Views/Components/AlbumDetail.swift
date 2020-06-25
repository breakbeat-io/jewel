//
//  AlbumView.swift
//  Listen Later
//
//  Created by Greg Hepworth on 06/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct AlbumDetail: View {
  
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
  let slot: Slot
  
  var body: some View {
    ScrollView {
      if horizontalSizeClass == .compact {
        Compact(slot: slot)
      } else {
        Regular(slot: slot)
      }
    }
  }
  
  struct Compact: View {
    
    let slot: Slot
    
    var body: some View {
      VStack {
        IfLet(slot.album?.attributes) { attributes in
          SourceCover(sourceName: attributes.name,
                     sourceArtist: attributes.artistName,
                     sourceArtwork: attributes.artwork.url(forWidth: 1000))
          PlaybackLinks(baseUrl: attributes.url,
                        playbackLinks: self.slot.playbackLinks)
            .padding(.bottom)
          IfLet(self.slot.album?.relationships?.tracks.data) { tracks in
            TrackList(tracks: tracks,
                      sourceArtist: attributes.artistName
            )
          }
        }
      }
      .padding()
    }
  }
  
  struct Regular: View {
    
    let slot: Slot
    
    var body: some View {
      HStack(alignment: .top) {
        IfLet(slot.album?.attributes) { attributes in
          VStack {
            SourceCover(sourceName: attributes.name,
                       sourceArtist: attributes.artistName,
                       sourceArtwork: attributes.artwork.url(forWidth: 1000))
            PlaybackLinks(baseUrl: attributes.url,
                          playbackLinks: self.slot.playbackLinks)
              .padding(.bottom)
          }
          VStack {
            IfLet(self.slot.album?.relationships?.tracks.data) { tracks in
              TrackList(tracks: tracks,
                        sourceArtist: attributes.artistName
              )
            }
            Spacer()
          }
        }
        .padding()
      }
    }
  }
  
}
