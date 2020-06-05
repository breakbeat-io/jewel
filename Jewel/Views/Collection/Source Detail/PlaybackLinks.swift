//
//  PlaybackLink.swift
//  Jewel
//
//  Created by Greg Hepworth on 30/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct PlaybackLinks: View {
  
  @EnvironmentObject var store: AppStore
  
  private var slot: Slot? {
    if let i = store.state.collection.selectedSlot {
      return store.state.collection.slots[i]
    }
    return nil
  }
  private var url: URL? {
    slot?.album?.attributes?.url
  }
  private var playbackLinks: OdesliResponse? {
    slot?.playbackLinks
  }
  
  @State private var showAdditionalLinks = false
  
  var body: some View {
    ZStack {
      IfLet(url) { url in
        PrimaryPlaybackLink()
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
              AlternativePlaybackLinks(playbackLinks: playbackLinks,
                                         showing: self.$showAdditionalLinks)
                .environmentObject(self.store)
            }
            .padding()
          }
        }
      }
    }
  }
}
