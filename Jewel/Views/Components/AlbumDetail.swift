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
    .onAppear{
      if slot.source != nil {
        completeSource(source: slot.source!, inSlot: slot, inCollection: collection.id)
      }
    }
  }
  
  struct Compact: View {
    
    @EnvironmentObject var app: AppEnvironment
    
    let slot: Slot
    
    var body: some View {
      VStack {
        IfLet(slot.source?.album) { album in
          SourceCover(sourceName: album.title,
                      sourceArtist: album.artistName,
                      sourceArtwork: album.artwork?.url(width: 1000, height: 1000))
          PlaybackLinks(baseUrl: album.url!,
                        playbackLinks: self.slot.playbackLinks)
            .padding(.bottom)
          if let songs = slot.source?.songs {
            SongList(songs: songs, sourceArtist: album.artistName)
          } else if app.state.navigation.gettingSongs {
            ProgressView()
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
        IfLet(slot.source?.album) { album in
          VStack {
            SourceCover(sourceName: album.title,
                        sourceArtist: album.artistName,
                        sourceArtwork: album.artwork?.url(width: 1000, height: 1000))
            PlaybackLinks(baseUrl: album.url!,
                          playbackLinks: self.slot.playbackLinks)
              .padding(.bottom)
          }
          VStack {
            if let songs = slot.source?.songs {
              SongList(songs: songs, sourceArtist: album.artistName)
            } else if app.state.navigation.gettingSongs {
              ProgressView()
            }
            Spacer()
          }
        }
        .padding()
      }
    }
  }
  
  private func completeSource(source: Source, inSlot slotId: Slot, inCollection collectionId: UUID) {
    if slot.source?.songs == nil  {
      Task {
        app.update(action: NavigationAction.gettingSongs(true))
        async let songs = RecordStore.getSongs(for: source.album)
        try? await app.update(action: LibraryAction.addSongsToAlbum(songs: songs, albumId: source.album.id, collectionId: collectionId))
        app.update(action: NavigationAction.gettingSongs(false))
      }
    }
    
    if slot.playbackLinks == nil {
      if let baseUrl = source.album.url {
        Task {
          app.update(action: NavigationAction.gettingPlaybackLinks(true))
          async let playbackLinks = RecordStore.getPlaybackLinks(for: baseUrl)
          try? await app.update(action: LibraryAction.setPlaybackLinks(baseUrl: baseUrl, playbackLinks: playbackLinks, collectionId: collectionId))
          app.update(action: NavigationAction.gettingPlaybackLinks(false))
        }
      }
    }
  }
}
