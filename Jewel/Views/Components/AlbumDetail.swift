//
//  AlbumView.swift
//  Stacks
//
//  Created by Greg Hepworth on 06/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import MusicKit

struct AlbumDetail: View {
  
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
  @EnvironmentObject var app: AppEnvironment
  
  private var stack: Stack {
    if app.state.navigation.onRotationActive {
      return app.state.library.onRotation
    } else {
      return app.state.library.stacks.first(where: { $0.id == app.state.navigation.activeStackId })!
    }
  }
  
  private var slot: Slot {
    stack.slots[app.state.navigation.activeSlotIndex]
  }
  
  var body: some View {
    NavigationView {
      Group {
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
          Button {
            app.update(action: LibraryAction.removeAlbumFromSlot(slotIndex: app.state.navigation.activeSlotIndex, stackId: app.state.navigation.activeStackId!))
            app.update(action: NavigationAction.showAlbumDetail(false))
          } label: {
            Text(Image(systemName: "eject"))
              .font(.body)
              .foregroundColor(.red)
          }
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
  
  struct Compact: View {
    
    @EnvironmentObject var app: AppEnvironment
    
    let slot: Slot
    
    var body: some View {
      ScrollView {
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
          .scaledToFit()
          .frame(minWidth: 0, maxWidth: .infinity)
          ScrollView {
            VStack {
              if let tracks = album.tracks {
                TrackList(tracks: tracks, albumArtistName: album.artistName)
              }
              Spacer()
            }
          }
          .frame(minWidth: 0, maxWidth: .infinity)
        }
        
      }
      .padding()
    }
    
  }
}

