//
//  AlbumDetail.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import HMV

struct AlbumDetailCompact: View {
    
    @EnvironmentObject var userData: UserData
    var slotId: Int
    
    @State private var showAdditionalLinks = false
    
    var body: some View {
        
        VStack {
            AlbumCover(slotId: slotId)
            IfLet(userData.collection[slotId].album?.attributes?.url) { url in
                VStack {
                    ZStack {
                        HStack {
                            PrimaryPlaybackLink(slotId: self.slotId)
                        }
                        HStack {
                            Spacer()
                            Button(action: {
                                self.showAdditionalLinks.toggle()
                            }) {
                                Image(systemName: self.showAdditionalLinks ? "chevron.up" : "chevron.down")
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                        }
                    }
                    if self.showAdditionalLinks {
                        AdditionalPlaybackLinks(slotId: self.slotId)
                    }
                }
            }
            IfLet(userData.collection[slotId].album) { album in
                AlbumTrackList(slotId: self.slotId)
            }
        }
        .padding()
    }
}

struct AlbumDetail_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        AlbumDetailCompact(slotId: 0).environmentObject(userData)
    }
}
