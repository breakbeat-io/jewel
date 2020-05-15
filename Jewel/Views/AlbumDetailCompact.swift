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
    var slotIndex: Int
    
    var body: some View {
        
        VStack {
            AlbumCover(slotIndex: slotIndex)
            PlaybackLinks(slotIndex: slotIndex)
                .padding(.bottom)
            IfLet(userData.activeCollection.slots[slotIndex].source?.album) { album in
                AlbumTrackList(slotIndex: self.slotIndex)
            }
        }
        .padding()
    }
}

struct AlbumDetail_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        AlbumDetailCompact(slotIndex: 0).environmentObject(userData)
    }
}
