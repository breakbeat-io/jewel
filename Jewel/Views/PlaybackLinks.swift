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
    
    private var url: URL? {
        store.state.collection.slots[store.state.collection.selectedSlot!].album?.attributes?.url
    }
    private var playbackLinks: OdesliResponse? {
        store.state.collection.slots[store.state.collection.selectedSlot!].playbackLinks
    }
    
    @State private var showAdditionalLinks = false
    
    var body: some View {
        ZStack {
            IfLet(url) { url in
                PrimaryPlaybackLink()
                IfLet(self.playbackLinks) { links in
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showAdditionalLinks.toggle()
                        }) {
                            Image(systemName: "link")
                                .foregroundColor(.secondary)
                        }
                        .sheet(isPresented: self.$showAdditionalLinks) {
                            AdditionalPlaybackLinks(showing: self.$showAdditionalLinks)
                                .environmentObject(self.store)
                        }
                        .padding()
                    }
                }
            }
        }
    }
}
