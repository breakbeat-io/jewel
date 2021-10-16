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
  
  private var collection: Collection {
    if app.state.navigation.onRotationActive {
      return app.state.library.onRotation
    } else {
      return app.state.library.collections.first(where: { $0.id == app.state.navigation.activeCollectionId })!
    }
  }
  
  private var slot: Slot {
    self.collection.slots[app.state.navigation.activeSlotIndex]
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
          self.collection.type == .userCollection ?
            Button {
              self.app.update(action: LibraryAction.removeSourceFromSlot(slotIndex: app.state.navigation.activeSlotIndex, collectionId: app.state.navigation.activeCollectionId!))
              self.app.update(action: NavigationAction.showSourceDetail(false))
            } label: {
              Text(Image(systemName: "eject"))
                .font(.body)
                .foregroundColor(.red)
            }
          : nil
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
  
  struct Compact: View {
    
    let slot: Slot
    
    var body: some View {
      VStack {
        IfLet(slot.source) { album in
          SourceCover(sourceName: album.title,
                      sourceArtist: album.artistName,
                      sourceArtwork: album.artwork?.url(width: 1000, height: 1000))
          PlaybackLinks(baseUrl: album.url!,
                        playbackLinks: self.slot.playbackLinks)
            .padding(.bottom)
          IfLet(album.tracks) { tracks in
            TrackList(tracks: tracks,
                      sourceArtist: album.artistName
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
        IfLet(slot.source) { album in
          VStack {
            SourceCover(sourceName: album.title,
                        sourceArtist: album.artistName,
                        sourceArtwork: album.artwork?.url(width: 1000, height: 1000))
            PlaybackLinks(baseUrl: album.url!,
                          playbackLinks: self.slot.playbackLinks)
              .padding(.bottom)
          }
          VStack {
            IfLet(album.tracks) { tracks in
              TrackList(tracks: tracks,
                        sourceArtist: album.artistName
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
