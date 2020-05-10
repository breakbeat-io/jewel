//
//  PlaybackLink.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct PlaybackLink: View {
    
    @EnvironmentObject var userData: UserData
    var slotId: Int
    
    var body: some View {
        
        if let appleMusicUrl = userData.slots[self.slotId].album?.attributes?.url {
            let links = LinkProvider.getServiceLinks(appleMusicUrl: appleMusicUrl)
            print(links)
        }
        
        let playbackLink = Button(action: {
            if let url = self.userData.slots[self.slotId].album?.attributes?.url {
                UIApplication.shared.open(url)
            }
        }) {
        HStack {
            Image(systemName: "play.fill")
                .font(.headline)
            Text("Play in Apple Music")
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
        
        return playbackLink
    }
}

struct PlaybackLink_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        PlaybackLink(slotId: 0).environmentObject(userData)
    }

}
