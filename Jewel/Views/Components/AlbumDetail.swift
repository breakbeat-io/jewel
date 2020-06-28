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
  
  private var slot: Slot {
    if app.navigation.onRotationActive {
      return app.state.library.onRotation.slots[app.navigation.activeSlotIndex]
    } else {
      let collectionIndex = app.state.library.collections.firstIndex(where: { $0.id == app.navigation.activeCollectionId })!
      return app.state.library.collections[collectionIndex].slots[app.navigation.activeSlotIndex]
    }
  }
  
  var body: some View {
    NavigationView {
      ScrollView {
        if horizontalSizeClass == .compact {
          Compact(slot: slot)
        } else {
          Regular(slot: slot)
        }
      }
      .navigationBarTitle("", displayMode: .inline)
    .navigationBarItems(leading: Button(action: {
      self.app.navigation.showSourceDetail = false
    }) {
      Text("Close")
    })
    }
    .navigationViewStyle(StackNavigationViewStyle())
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
