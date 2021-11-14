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
            self.app.update(action: NavigationAction.showAlbumDetail(false))
          } label: {
            Text("Close")
              .font(.body)
          },
        trailing:
          self.collection.type == .userCollection ?
        Button {
          self.app.update(action: LibraryAction.removeAlbumFromSlot(slotIndex: app.state.navigation.activeSlotIndex, collectionId: app.state.navigation.activeCollectionId!))
          self.app.update(action: NavigationAction.showAlbumDetail(false))
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
    
    @EnvironmentObject var app: AppEnvironment
    
    let slot: Slot
    
    var body: some View {
      VStack {
        if let album = slot.album {
          AlbumCover(albumTitle: album.title,
                      albumArtistName: album.artistName,
                      albumArtwork: album.artwork?.url(width: 1000, height: 1000))
          PlaybackLinks(baseUrl: album.url!,
                        playbackLinks: self.slot.playbackLinks)
            .padding(.bottom)
//          SongList(songs: songs, albumArtistName: album.artistName)
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
                          playbackLinks: self.slot.playbackLinks)
              .padding(.bottom)
          }
          VStack {
//            SongList(songs: songs, albumArtistName: album.artistName)
            Spacer()
          }
        }
        
      }
      .padding()
    }
  }
  
//  private func completeAlbum(album: Album, inSlot slotId: Slot, inCollection collectionId: UUID) {
////    if slot.album?.songs == nil  {
////      Task {
////        app.update(action: NavigationAction.gettingSongs(true))
////        async let songs = RecordStore.getSongs(for: album.album)
////        try? await app.update(action: LibraryAction.addSongsToAlbum(songs: songs, albumId: album.album.id, collectionId: collectionId))
////        app.update(action: NavigationAction.gettingSongs(false))
////      }
////    }
//    
//    if slot.playbackLinks == nil {
//      if let baseUrl = album.url {
//        Task {
//          app.update(action: NavigationAction.gettingPlaybackLinks(true))
//          async let playbackLinks = RecordStore.getPlaybackLinks(for: baseUrl)
//          try? await app.update(action: LibraryAction.setPlaybackLinks(baseUrl: baseUrl, playbackLinks: playbackLinks, collectionId: collectionId))
//          app.update(action: NavigationAction.gettingPlaybackLinks(false))
//        }
//      }
//    }
//  }
}
