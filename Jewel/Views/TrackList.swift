//
//  TrackList.swift
//  Jewel
//
//  Created by Greg Hepworth on 24/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct TrackList: View {
    
    @EnvironmentObject var wallet: WalletViewModel
    var slotId: Int
    
    var body: some View {
        
        var numberOfDiscs = 0
        
        if let tracks = wallet.slots[slotId].album?.relationships?.tracks.data {
            var discs = [Int]()
            for i in 0..<tracks.count {
                discs.append(tracks[i].attributes!.discNumber)
            }
            numberOfDiscs = discs.max()!
        }
        
        let tracklist = VStack(alignment: .leading) {
            ForEach(1..<numberOfDiscs + 1) { i in
                if numberOfDiscs > 1 {
                    Text("Disc \(i)")
                        .fontWeight(.bold)
                        .padding(.vertical)
                }
                TrackListItem(slotId: self.slotId, discNumber: i)
            }
        }
        
        return tracklist
    }
}

struct TrackList_Previews: PreviewProvider {
    static var previews: some View {
        TrackList(slotId: 0)
    }
}
