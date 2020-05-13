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
    
    var body: some View {
        
        VStack {
            AlbumCover(slotId: slotId)
            PlaybackLinks(slotId: slotId)
                .padding(.bottom)
            IfLet(userData.collection.slots[slotId].source?.album) { album in
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
