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
    
    @State private var showAdditionalLinks = false
    
    var body: some View {
        IfLet(userData.collection.slots[slotIndex].source?.album?.attributes?.url) { url in
            ZStack {
                PrimaryPlaybackLink(slotIndex: self.slotIndex)
                if self.userData.collection.slots[self.slotIndex].playbackLinks != nil {
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

struct PlaybackLinks_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        PlaybackLinks(slotIndex: 0).environmentObject(userData)
    }
}
