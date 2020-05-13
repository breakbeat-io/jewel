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
    var slotId: Int
    
    @State private var showAdditionalLinks = false
    
    var body: some View {
        IfLet(userData.collection.slots[slotId].album?.attributes?.url) { url in
            ZStack {
                PrimaryPlaybackLink(slotId: self.slotId)
                if self.userData.collection.slots[self.slotId].playbackLinks != nil {
                    HStack {
                        Spacer()
                        Button(action: {
                            self.showAdditionalLinks.toggle()
                        }) {
                            Image(systemName: "link")
                                .foregroundColor(.secondary)
                        }
                        .sheet(isPresented: self.$showAdditionalLinks) {
                            AdditionalPlaybackLinks(slotId: self.slotId).environmentObject(self.userData)
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
        PlaybackLinks(slotId: 0).environmentObject(userData)
    }
}
