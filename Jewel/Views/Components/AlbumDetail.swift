//
//  AlbumView.swift
//  Listen Later
//
//  Created by Greg Hepworth on 06/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import MusicKit

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
    collection.slots[app.state.navigation.activeSlotIndex]
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
            app.update(action: NavigationAction.showAlbumDetail(false))
          } label: {
            Text("Close")
              .font(.body)
          },
        trailing:
          collection.type == .userCollection ?
        Button {
          app.update(action: LibraryAction.removeAlbumFromSlot(slotIndex: app.state.navigation.activeSlotIndex, collectionId: app.state.navigation.activeCollectionId!))
          app.update(action: NavigationAction.showAlbumDetail(false))
        } label: {
          Text(Image(systemName: "eject"))
            .font(.body)
            .foregroundColor(.red)
        }
        : nil
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
    .onAppear {
      if slot.playbackLinks == nil {
        guard let baseUrl = slot.album?.url else { return }
        Task {
          app.update(action: NavigationAction.gettingPlaybackLinks(true))
          async let playbackLinks = RecordStore.getPlaybackLinks(for: baseUrl)
          try? await app.update(action: LibraryAction.setPlaybackLinks(baseUrl: baseUrl, playbackLinks: playbackLinks, collectionId: collection.id))
          app.update(action: NavigationAction.gettingPlaybackLinks(false))
        }
      }
    }
  }
  
  struct Compact: View {
    
    @EnvironmentObject var app: AppEnvironment
    
    let slot: Slot
    
    var body: some View {
      VStack {
        if let album = slot.album {
          AlbumCover(albumTitle: album.title,
                      albumArtistName: album.artistName,
                      albumArtwork: album.artwork?.url(width: 1000, height: 1000))
          PlaybackLinks(baseUrl: album.url!,
                        playbackLinks: slot.playbackLinks)
            .padding(.bottom)
          if let tracks = album.tracks {
            TrackList(tracks: tracks, albumArtistName: album.artistName)
          }
        }
      }
      .padding()
    }
  }
  
  struct Regular: View {
    
    @EnvironmentObject var app: AppEnvironment
    
    let slot: Slot
    
    var body: some View {
      HStack(alignment: .top) {
        if let album = slot.album {
          VStack {
            AlbumCover(albumTitle: album.title,
                        albumArtistName: album.artistName,
                        albumArtwork: album.artwork?.url(width: 1000, height: 1000))
            PlaybackLinks(baseUrl: album.url!,
                          playbackLinks: slot.playbackLinks)
              .padding(.bottom)
          }
          VStack {
            if let tracks = album.tracks {
              TrackList(tracks: tracks, albumArtistName: album.artistName)
            }
            Spacer()
          }
        }
        
      }
      .padding()
    }
  }
  
}
