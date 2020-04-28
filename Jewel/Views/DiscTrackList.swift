//
//  DiscTrackList.swift
//  Jewel
//
//  Created by Greg Hepworth on 28/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct DiscTrackList: View {
    
    @EnvironmentObject var wallet: WalletViewModel
    var slotId: Int
    var discNumber: Int
    
    var body: some View {
        
        Unwrap(wallet.slots[slotId].album?.relationships?.tracks.data) { tracks in
            ForEach(0..<tracks.count) { i in
                Unwrap(tracks[i].attributes) { track in
                    HStack {
                        Text(String(track.trackNumber))
                            .font(.footnote)
                            .frame(width: 20, alignment: .center)
                            .padding(.vertical)
                            .padding(.trailing)
                        VStack(alignment: .leading) {
                            Text(track.name)
                                .font(.callout)
                                .fontWeight(.medium)
                                .lineLimit(1)
                            if track.artistName as String != self.wallet.slots[self.slotId].album?.attributes?.artistName {
                                Text(track.artistName)
                                    .font(.callout)
                                    .fontWeight(.light)
                                    .opacity(0.7)
                                    .lineLimit(1)
                            }
                        }
                        Spacer()
                        Unwrap(track.duration()) { duration in
                            Text(duration)
                                .font(.footnote)
                                .opacity(0.7)
                        }
                    }
                }
            }
        }
    }
}

struct DiscTrackList_Previews: PreviewProvider {
    static var previews: some View {
        DiscTrackList(slotId: 1, discNumber: 1)
    }
}
