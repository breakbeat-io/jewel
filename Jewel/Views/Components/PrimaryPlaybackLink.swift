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
    
    var body: some View {
        
        var playbackLink: URL?
        var playbackName: String
        
        let preferredProvider = OdesliPlatform.allCases[userData.preferences.preferredMusicPlatform]
        
        if let providerLink = userData.activeCollection.slots[slotIndex].playbackLinks?.linksByPlatform[preferredProvider.rawValue] {
            playbackLink = providerLink.url
            playbackName = preferredProvider.friendlyName
        } else {
            playbackLink = userData.activeCollection.slots[slotIndex].source?.content?.attributes?.url
            playbackName = OdesliPlatform.appleMusic.friendlyName
        }
        
        let playbackLinkView =
            IfLet(playbackLink) { url in
                Button(action: {
                    UIApplication.shared.open(url)
                }) {
                    HStack {
                        Image(systemName: "play.fill")
                            .font(.headline)
                        Text("Play in \(playbackName)")
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
        
        return playbackLinkView
    }
}

