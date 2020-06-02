//
//  PrimaryPlaybackLink.swift
//  Listen Later
//
//  Created by Greg Hepworth on 02/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct PrimaryPlaybackLink: View {
    
    @EnvironmentObject var store: AppStore
    
    private var playbackLink: (name: String, url: URL?) {
        let preferredProvider = OdesliPlatform.allCases[store.state.options.preferredMusicPlatform]
        if let providerLink = store.state.collection.slots[store.state.collection.selectedSlot!].playbackLinks?.linksByPlatform[preferredProvider.rawValue] {
            return (preferredProvider.friendlyName, providerLink.url)
        } else {
            return (OdesliPlatform.appleMusic.friendlyName, store.state.collection.slots[store.state.collection.selectedSlot!].album?.attributes?.url)
        }
    }
    
    var body: some View {
        Button(action: {
            if let url = self.playbackLink.url {
                UIApplication.shared.open(url)
        }
        }) {
            HStack {
                Image(systemName: "play.fill")
                    .font(.headline)
                Text("Play in \(playbackLink.name)")
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
