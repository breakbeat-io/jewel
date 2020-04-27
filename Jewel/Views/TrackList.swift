//
//  TrackList.swift
//  Jewel
//
//  Created by Greg Hepworth on 24/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import HMV

struct TrackList: View {
    
    @EnvironmentObject var wallet: WalletViewModel
    var slotId: Int
    
    var body: some View {
        
        ForEach(0..<(wallet.slots[slotId].album?.relationships?.tracks.data!.count)!) { i in
            HStack {
                Text("x")
                    .padding()
                VStack(alignment: .leading) {
                    Text(self.wallet.slots[self.slotId].album!.relationships!.tracks.data![i].attributes!.name)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    Text(self.wallet.slots[self.slotId].album!.relationships!.tracks.data![i].attributes!.artistName)
                        .fontWeight(.light)
                        .lineLimit(1)
                }
                Spacer()
                Text("--:--")
                    .padding()
            }
        }
    }
}

//struct TrackList_Previews: PreviewProvider {
//    static var previews: some View {
//        TrackList()
//    }
//}
