//
//  PlaybackLink.swift
//  Jewel
//
//  Created by Greg Hepworth on 30/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct LibraryPlaybackLinks: View {
  
  var slot: Slot
  
  private var url: URL? {
    slot.album?.attributes?.url
  }
  private var playbackLinks: OdesliResponse? {
    slot.playbackLinks
  }
  
  @State private var showAdditionalLinks = false
  
  var body: some View {
    ZStack {
      IfLet(url) { url in
        LibraryPrimaryPlaybackLink(slot: self.slot)
        IfLet(self.playbackLinks) { playbackLinks in
          HStack {
            Spacer()
            Button(action: {
              self.showAdditionalLinks.toggle()
            }) {
              Image(systemName: "link")
                .foregroundColor(.secondary)
            }
            .sheet(isPresented: self.$showAdditionalLinks) {
              NewAdditionalPlaybackLinks(playbackLinks: playbackLinks,
                                         showing: self.$showAdditionalLinks)
            }
            .padding()
          }
        }
      }
    }
  }
}
