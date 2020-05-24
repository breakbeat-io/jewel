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

struct SourceDetailRegular: View {
    
    @EnvironmentObject var collections: Collections
    
    var slotIndex: Int
    private var notes: String? {
        collections.activeCollection.slots[slotIndex].source?.content?.attributes?.editorialNotes?.standard
    }
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                AlbumCover(slotIndex: slotIndex)
                PlaybackLinks(slotIndex: slotIndex)
                    .padding(.bottom)
                IfLet(notes) { notes in
                    Text(notes)
                }
            }
            VStack {
                AlbumTrackList(slotIndex: self.slotIndex)
                .padding(.horizontal)
                Spacer()
            }
        }
        .padding()
    }
}

