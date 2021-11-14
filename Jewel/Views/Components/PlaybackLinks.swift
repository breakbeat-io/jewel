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
    let preferredProvider = OdesliPlatform.allCases[AppEnvironment.global.state.settings.preferredMusicPlatform]
    if let providerLink = playbackLinks?.linksByPlatform[preferredProvider.rawValue] {
      return (preferredProvider.friendlyName, providerLink.url)
    } else {
      return (OdesliPlatform.appleMusic.friendlyName, baseUrl)
    }
  }
  
  private var showPlaybackLinks: Binding<Bool> { Binding (
    get: { self.app.state.navigation.showPlaybackLinks },
    set: { if self.app.state.navigation.showPlaybackLinks { self.app.update(action: NavigationAction.showPlaybackLinks($0)) } }
  )}
  
  var body: some View {
    if let url = playbackLink.url {
      ZStack {
        PlaybackLink(url: url, platformName: self.playbackLink.name)
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
                .environmentObject(self.app)
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
