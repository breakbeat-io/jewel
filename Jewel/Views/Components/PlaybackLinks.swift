//
//  NewPlaybackLinks.swift
//  Listen Later
//
//  Created by Greg Hepworth on 06/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct PlaybackLinks: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  let baseUrl: URL
  let playbackLinks: OdesliResponse?
  
  private var playbackLink: (name: String, url: URL?) {
    let preferredMusicPlatform = AppEnvironment.global.state.settings.preferredMusicPlatform
    if let musicPlatformLink = playbackLinks?.linksByPlatform[preferredMusicPlatform.rawValue] {
      return (String(describing: preferredMusicPlatform), musicPlatformLink.url)
    } else {
      return (String(describing: OdesliPlatform.appleMusic), baseUrl)
    }
  }
  
  private var showPlaybackLinks: Binding<Bool> { Binding (
    get: { app.state.navigation.showPlaybackLinks },
    set: { if app.state.navigation.showPlaybackLinks { app.update(action: NavigationAction.showPlaybackLinks($0)) } }
  )}
  
  var body: some View {
    if let url = playbackLink.url {
      ZStack {
        PlaybackLink(url: url, platformName: playbackLink.name)
        HStack {
          Spacer()
          if let playbackLinks = playbackLinks {
            Button {
              app.update(action: NavigationAction.showPlaybackLinks(true))
            } label: {
              Text(Image(systemName: "link"))
                .foregroundColor(.secondary)
            }
            .sheet(isPresented: showPlaybackLinks) {
              AlternativePlaybackLinks(playbackLinks: playbackLinks)
                .environmentObject(app)
            }
            .padding()
          } else if app.state.navigation.gettingPlaybackLinks {
            ProgressView()
              .padding()
          }
        }
      }
    }
  }
}
