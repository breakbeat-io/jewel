//
//  NewPlaybackLinks.swift
//  Listen Later
//
//  Created by Greg Hepworth on 06/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct PlaybackLinks: View {
  
  let baseUrl: URL
  let playbackLinks: OdesliResponse?
  
  private var playbackLink: (name: String, url: URL?) {
    let preferredProvider = OdesliPlatform.allCases[AppEnvironment.global.state.options.preferredMusicPlatform]
    if let providerLink = playbackLinks?.linksByPlatform[preferredProvider.rawValue] {
      return (preferredProvider.friendlyName, providerLink.url)
    } else {
      return (OdesliPlatform.appleMusic.friendlyName, baseUrl)
    }
  }
  
  @State private var showAlternativeLinks = false
  
  var body: some View {
    IfLet(playbackLink.url) { url in
      ZStack {
        PlaybackLink(url: url,
                     platformName: self.playbackLink.name)
        IfLet(self.playbackLinks) { playbackLinks in
          HStack {
            Spacer()
            Button(action: {
              self.showAlternativeLinks.toggle()
            }) {
              Image(systemName: "link")
                .foregroundColor(.secondary)
            }
            .sheet(isPresented: self.$showAlternativeLinks) {
              AlternativePlaybackLinks(playbackLinks: playbackLinks,
                                       showing: self.$showAlternativeLinks)
            }
            .padding()
          }
        }
      }
    }
  }
}
