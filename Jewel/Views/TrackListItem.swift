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
    var discNumber: Int
    
    var body: some View {
        
        let tracks = wallet.slots[slotId].album?.relationships?.tracks.data!
        let albumArtist = wallet.slots[self.slotId].album?.attributes?.artistName

        let item = ForEach(0..<(tracks!.count)) { i in
            if tracks![i].attributes!.discNumber == self.discNumber {
                HStack {
                    Text(String(tracks![i].attributes!.trackNumber))
                        .font(.footnote)
                        .frame(width: 20, alignment: .center)
                        .padding(.vertical)
                        .padding(.trailing)
                    VStack(alignment: .leading) {
                        Text(tracks![i].attributes!.name)
                            .font(.callout)
                            .fontWeight(.medium)
                            .lineLimit(1)
                        if tracks![i].attributes!.artistName != albumArtist {
                            Text(tracks![i].attributes!.artistName)
                                .font(.callout)
                                .fontWeight(.light)
                                .opacity(0.7)
                                .lineLimit(1)
                        }
                    }
                    Spacer()
                    Text(tracks![i].attributes!.duration()!)
                        .font(.footnote)
                        .opacity(0.7)
                }
            }
        }
        
        return item
    }
}

struct TrackListItem_Previews: PreviewProvider {
    static var previews: some View {
        TrackListItem(slotId: 1, discNumber: 1)
    }
}
