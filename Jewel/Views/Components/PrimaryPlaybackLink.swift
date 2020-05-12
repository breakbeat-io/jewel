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
    var slotId: Int
    
    var body: some View {
        
        let preferredProvider = OdesliPlatform.allCases[userData.prefs.primaryMusicProvider]
        
        let playbackLink = userData.collection[slotId].playbackLinks?.linksByPlatform[preferredProvider.rawValue]
            
        let playbackLinkView = VStack {
            Button(action: {
                if let url = playbackLink?.url {
                    UIApplication.shared.open(url)
                }
            }) {
                HStack {
                    Image(systemName: "play.fill")
                        .font(.headline)
                    Text("Play in \(preferredProvider.friendlyName)")
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

struct PlaybackLink_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        PrimaryPlaybackLink(slotId: 0).environmentObject(userData)
    }

}
