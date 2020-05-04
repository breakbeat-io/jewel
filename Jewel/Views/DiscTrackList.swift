//
//  DiscTrackList.swift
//  Jewel
//
//  Created by Greg Hepworth on 28/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct DiscTrackList: View {
    
    @EnvironmentObject var userData: UserData
    var slotId: Int
    var discNumber: Int
    
    var body: some View {
        
        let discTrackList = Unwrap(userData.slots[slotId].album?.relationships?.tracks.data) { tracks in
            ForEach(0..<tracks.count) { i in
                Unwrap(tracks[i].attributes?.discNumber) { trackDiscNumber in
                    if trackDiscNumber == self.discNumber {
                        TrackListItem(slotId: self.slotId, trackId: i)
                    }
                }
            }
        }
        return discTrackList
    }
}

struct DiscTrackList_Previews: PreviewProvider {
    static var previews: some View {
        DiscTrackList(slotId: 1, discNumber: 1)
    }
}
