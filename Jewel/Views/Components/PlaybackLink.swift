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
    @EnvironmentObject var linkProvider: LinkProvider
    var slotId: Int
    
    var body: some View {
        
        if let appleMusicUrl = userData.slots[self.slotId].album?.attributes?.url {
            linkProvider.getServiceLinks(appleMusicUrl: appleMusicUrl)
        }
        
        let playbackLink =
            
        VStack {
            Button(action: {
                if let links = self.linkProvider.links {
                    UIApplication.shared.open(links.linksByPlatform["youtube"]!.url)
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
            HStack {
                Group {
                    Text(verbatim: "\u{f167}") // youtube
                    Text(verbatim: "\u{f179}") // apple
                    Text("T") // TIDAL
                    Text("D") // Deezer
                    Text(verbatim: "\u{f3ab}") // google play
                    Text(verbatim: "\u{f270}") // amazon
                    Text(verbatim: "\u{f1be}") // soundcloud
                    Text(verbatim: "\u{f3d2}") // napster
                }
                    .font(.custom("FontAwesome5Brands-Regular", size: 24))
            }
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
