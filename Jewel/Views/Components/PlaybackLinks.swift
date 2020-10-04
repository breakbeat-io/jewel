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
  
  private var showAlternativeLinks: Binding<Bool> { Binding (
    get: { self.app.state.navigation.showAlternativeLinks },
    set: { if self.app.state.navigation.showAlternativeLinks { self.app.update(action: NavigationAction.showAlternativeLinks($0)) } }
  )}
  
  var body: some View {
    IfLet(playbackLink.url) { url in
      ZStack {
        PlaybackLink(url: url, platformName: self.playbackLink.name)
        IfLet(self.playbackLinks) { playbackLinks in
          HStack {
            Spacer()
            Button {
              self.app.update(action: NavigationAction.showAlternativeLinks(true))
            } label: {
              Text(Image(systemName: "link"))
                .foregroundColor(.secondary)
            }
            .sheet(isPresented: self.showAlternativeLinks) {
              AlternativePlaybackLinks(playbackLinks: playbackLinks)
                .environmentObject(self.app)
            }
            .padding()
          }
        }
      }
    }
  }
}
