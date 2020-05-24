//
//  PlaybackLinks.swift
//  Jewel
//
//  Created by Greg Hepworth on 12/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct PlaybackLinks: View {
    
    @EnvironmentObject var collections: Collections
    
    @State private var showAdditionalLinks = false
    
    var slotIndex: Int
    private var url: URL? {
        collections.activeCollection.slots[slotIndex].source?.content?.attributes?.url
    }
    private var playbackLinks: OdesliResponse? {
        collections.activeCollection.slots[slotIndex].playbackLinks
    }
    
    var body: some View {
        ZStack {
            IfLet(url) { url in
                PrimaryPlaybackLink(slotIndex: self.slotIndex)
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
                            AdditionalPlaybackLinks(slotIndex: self.slotIndex)
                                .environmentObject(self.collections)
                        }
                        .padding()
                    }
                }
            }
        }
    }
}
