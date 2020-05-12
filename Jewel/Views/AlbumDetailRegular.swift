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
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var userData: UserData
    var slotId: Int
    
    var body: some View {
        HStack(alignment: .top) {
            VStack {
                AlbumCover(slotId: slotId)
                IfLet(userData.collection[slotId].album?.attributes?.url) { url in
                    VStack(alignment: .center) {
                        PrimaryPlaybackLink(slotId: self.slotId)
                        AdditionalPlaybackLinks(slotId: self.slotId)
                    }.padding()
                }
                IfLet(userData.collection[slotId].album?.attributes?.editorialNotes?.standard) { notes in
                    Text(notes)
                }
            }
            VStack {
                IfLet(userData.collection[slotId].album) { album in
                    AlbumTrackList(slotId: self.slotId)
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
        AlbumDetailRegular(slotId: 0).environmentObject(userData)
    }
}
