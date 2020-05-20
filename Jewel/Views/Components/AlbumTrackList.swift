//
//  AlbumTrackList.swift
//  Jewel
//
//  Created by Greg Hepworth on 24/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct AlbumTrackList: View {
    
    @EnvironmentObject var userData: UserData
    var slotIndex: Int
    
    var body: some View {
        
        let tracks = userData.activeCollection.slots[slotIndex].source?.content?.relationships?.tracks.data
        let discCount = tracks?.map { $0.attributes?.discNumber ?? 1 }.max()
        
        let albumTrackList = VStack(alignment: .leading) {
            IfLet(discCount) { discCount in
                ForEach(1..<discCount + 1, id: \.self) {
                    DiscTrackList(slotIndex: self.slotIndex, discNumber: $0, withTitle: (discCount > 1) ? true : false)
                }
            }
        }
        
        return albumTrackList
    }
}
