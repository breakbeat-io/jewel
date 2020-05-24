//
//  AlbumTrackList.swift
//  Jewel
//
//  Created by Greg Hepworth on 24/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import HMV

struct AlbumTrackList: View {
    
    @EnvironmentObject var collections: Collections
    
    var slotIndex: Int
    private var discCount: Int? {
        collections.activeCollection.slots[slotIndex].source?.content?.relationships?.tracks.data?.map { $0.attributes?.discNumber ?? 1 }.max()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            IfLet(discCount) { discCount in
                ForEach(1..<discCount! + 1, id: \.self) {
                    DiscTrackList(slotIndex: self.slotIndex, discNumber: $0, withTitle: (discCount! > 1) ? true : false)
                }
            }
        }
    }
}
