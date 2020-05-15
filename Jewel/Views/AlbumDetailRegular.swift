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

struct AlbumDetailRegular: View {
    
    @EnvironmentObject var userData: UserData
    var slotIndex: Int
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                AlbumCover(slotIndex: slotIndex)
                PlaybackLinks(slotIndex: slotIndex)
                    .padding(.bottom)
                IfLet(userData.activeCollection.slots[slotIndex].source?.album?.attributes?.editorialNotes?.standard) { notes in
                    Text(notes)
                }
            }
            VStack {
                IfLet(userData.activeCollection.slots[slotIndex].source?.album) { album in
                    AlbumTrackList(slotIndex: self.slotIndex)
                }.padding(.horizontal)
                Spacer()
            }
        }
        .padding()
    }
}

struct AlbumDetailRegular_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        AlbumDetailRegular(slotIndex: 0).environmentObject(userData)
    }
}
