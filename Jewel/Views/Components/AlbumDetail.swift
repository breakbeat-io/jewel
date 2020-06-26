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
  
  @EnvironmentObject var app: AppEnvironment
  
  let slot: Slot
  
  var body: some View {
    VStack {
      HStack {
        Spacer()
        Button(action: {
          self.app.navigation.showSourceDetail = false
        }) {
          Text("Close")
        }
      }
      .padding([.top, .horizontal])
      ScrollView {
        if horizontalSizeClass == .compact {
          Compact(slot: slot)
        } else {
          Regular(slot: slot)
        }
      }
    }
  }
  
  struct Compact: View {
    
    let slot: Slot
    
    var body: some View {
      VStack {
        IfLet(slot.source?.attributes) { attributes in
          SourceCover(sourceName: attributes.name,
                     sourceArtist: attributes.artistName,
                     sourceArtwork: attributes.artwork.url(forWidth: 1000))
          PlaybackLinks(baseUrl: attributes.url,
                        playbackLinks: self.slot.playbackLinks)
            .padding(.bottom)
          IfLet(self.slot.source?.relationships?.tracks.data) { tracks in
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
        IfLet(slot.source?.attributes) { attributes in
          VStack {
            SourceCover(sourceName: attributes.name,
                       sourceArtist: attributes.artistName,
                       sourceArtwork: attributes.artwork.url(forWidth: 1000))
            PlaybackLinks(baseUrl: attributes.url,
                          playbackLinks: self.slot.playbackLinks)
              .padding(.bottom)
          }
          VStack {
            IfLet(self.slot.source?.relationships?.tracks.data) { tracks in
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
