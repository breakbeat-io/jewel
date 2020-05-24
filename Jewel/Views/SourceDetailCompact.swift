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

struct SourceDetailCompact: View {
    
    @EnvironmentObject var collections: Collections
    
    var slotIndex: Int
    
    var body: some View {
        VStack {
            AlbumCover(slotIndex: slotIndex)
            PlaybackLinks(slotIndex: slotIndex)
                .padding(.bottom)
            AlbumTrackList(slotIndex: self.slotIndex)
        }
        .padding()
    }
}
