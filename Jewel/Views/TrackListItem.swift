//
//  TrackListItem.swift
//  Jewel
//
//  Created by Greg Hepworth on 28/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct TrackListItem: View {
    
    @EnvironmentObject var wallet: WalletViewModel
    var slotId: Int
    
    var body: some View {
        
        let tracks = wallet.slots[slotId].album?.relationships?.tracks.data!

        let item = ForEach(0..<(tracks!.count)) { i in
            HStack {
                Text(String(tracks![i].attributes!.trackNumber))
                    .padding()
                VStack(alignment: .leading) {
                    Text(tracks![i].attributes!.name)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    Text(tracks![i].attributes!.artistName)
                        .fontWeight(.light)
                        .lineLimit(1)
                }
                Spacer()
                Text(tracks![i].attributes!.duration()!)
                    .padding()
            }
        }
        return item
    }
}

struct TrackListItem_Previews: PreviewProvider {
    static var previews: some View {
        TrackListItem(slotId: 1)
    }
}
