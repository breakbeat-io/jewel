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
    var slotId: Int
    
    var body: some View {
        
        let numberOfDiscs = userData.slots[slotId].album?.discCount() ?? 1
        
        let tracklist = VStack(alignment: .leading) {
            ForEach(1..<numberOfDiscs + 1) { i in
                if numberOfDiscs > 1 {
                    Text("Disc \(i)")
                        .fontWeight(.bold)
                        .padding(.vertical)
                }
                DiscTrackList(slotId: self.slotId, discNumber: i)
            }.foregroundColor(Color.black)
        }
        
        return tracklist
    }
}

struct TrackList_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        AlbumTrackList(slotId: 0).environmentObject(userData)
    }
}
