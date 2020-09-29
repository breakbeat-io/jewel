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
    if app.state.navigation.onRotationActive {
      return app.state.library.onRotation.slots[app.state.navigation.activeSlotIndex]
    } else {
      let collectionIndex = app.state.library.collections.firstIndex(where: { $0.id == app.state.navigation.activeCollectionId })!
      return app.state.library.collections[collectionIndex].slots[app.state.navigation.activeSlotIndex]
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
      .navigationBarItems(
        leading:
          Button {
            self.app.update(action: NavigationAction.showSourceDetail(false))
          } label: {
            Text("Close")
              .font(.body)
          },
        trailing:
          Button {
            self.app.update(action: LibraryAction.removeSourceFromSlot(slotIndex: app.state.navigation.activeSlotIndex, collectionId: app.state.navigation.activeCollectionId!))
            self.app.update(action: NavigationAction.showSourceDetail(false))
          } label: {
            Text(Image(systemName: "eject"))
              .font(.body)
              .foregroundColor(.red)
            //shouldn't be possible if not a suser collectioN!
          }
      )
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
