//
//  AlternativePlaybackLinks.swift
//  Jewel
//
//  Created by Greg Hepworth on 12/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct AdditionalPlaybackLinks: View {
    var body: some View {
        Text("Alternative Playback Links")
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
}

struct AlternativePlaybackLinks_Previews: PreviewProvider {
    static var previews: some View {
        AdditionalPlaybackLinks()
    }
}
