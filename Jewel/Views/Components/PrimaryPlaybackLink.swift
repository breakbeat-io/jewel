//
//  PlaybackLink.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct PrimaryPlaybackLink: View {
    
    @EnvironmentObject var userData: UserData
    var slotIndex: Int
    
    var playbackDetails: (name: String, url: URL) {
        let preferredProvider = OdesliPlatform.allCases[userData.preferences.preferredMusicPlatform]
        
        if let providerLink = userData.activeCollection.slots[slotIndex].playbackLinks?.linksByPlatform[preferredProvider.rawValue] {
            return (preferredProvider.friendlyName, providerLink.url)
        } else {
            return (OdesliPlatform.appleMusic.friendlyName, userData.activeCollection.slots[slotIndex].source!.content!.attributes!.url)
        }
    }
    
    var body: some View {
        Group {
            Button(action: {
                UIApplication.shared.open(self.playbackDetails.url)
            }) {
                HStack {
                    Image(systemName: "play.fill")
                        .font(.headline)
                    Text("Play in \(playbackDetails.name)")
                        .font(.headline)
                }
                .padding()
                .foregroundColor(.primary)
                .cornerRadius(40)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color.primary, lineWidth: 2)
                )
            }
        }
    }
}

