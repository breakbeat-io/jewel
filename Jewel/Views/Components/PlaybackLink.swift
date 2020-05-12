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
        
        //get the preferred provider
        
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
//            VStack {
//                Group {
//                    ForEach(OdesliPlatform.allCases, id: \.self) { platform in
//                        IfLet(self.userData.collection[self.slotId].playbackLinks?.linksByPlatform[platform.rawValue]?.url) { url in
//                            Button(action: {
//                                UIApplication.shared.open(url)
//                            }) {
//                                HStack {
//                                    Text(platform.rawValue)
//                                }
//                                .padding()
//                            }
//                        }
//                    }
//
////                    Text(verbatim: "\u{f167}") // youtube
////                    Text(verbatim: "\u{f179}") // apple
////                    Text("T") // TIDAL
////                    Text("D") // Deezer
////                    Text(verbatim: "\u{f3ab}") // google play
////                    Text(verbatim: "\u{f270}") // amazon
////                    Text(verbatim: "\u{f1be}") // soundcloud
////                    Text(verbatim: "\u{f3d2}") // napster
//                }
//                .font(.custom("FontAwesome5Brands-Regular", size: 24))
//                .foregroundColor(.primary)
//
//            }
        }
        
        return playbackLinkView
    }
}

struct PlaybackLink_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        PlaybackLink(slotId: 0).environmentObject(userData)
    }

}
