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
    
    var url: URL
    var playbackLinks: OdesliResponse?
    
    @State private var showAdditionalLinks = false
    
    var body: some View {
        ZStack {
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
