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
    
    private var selectedSlot: Int? {
        store.state.collection.selectedSlot
    }
    private var url: URL? {
        if let i = selectedSlot {
            return store.state.collection.slots[i].album?.attributes?.url
        }
        return nil
    }
    private var playbackLinks: OdesliResponse? {
        if let i = selectedSlot {
            return store.state.collection.slots[i].playbackLinks
        }
        return nil
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
