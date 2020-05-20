//
//  PlaybackLinks.swift
//  Jewel
//
//  Created by Greg Hepworth on 12/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct PlaybackLinks: View {
    
    @EnvironmentObject var userData: UserData
    var slotIndex: Int
    
    var url: URL? {
        return userData.activeCollection.slots[slotIndex].source?.content?.attributes?.url
    }
    var playbackLinks: OdesliResponse? {
        return userData.activeCollection.slots[slotIndex].playbackLinks
    }
    
    @State private var showAdditionalLinks = false
    
    var body: some View {
        ZStack {
            if url != nil {
                PrimaryPlaybackLink(slotIndex: self.slotIndex)
                if playbackLinks != nil {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showAdditionalLinks.toggle()
                        }) {
                            Image(systemName: "link")
                                .foregroundColor(.secondary)
                        }
                        .sheet(isPresented: self.$showAdditionalLinks) {
                            AdditionalPlaybackLinks(slotIndex: self.slotIndex).environmentObject(self.userData)
                        }
                        .padding()
                    }
                }
            }
        }
    }
}
