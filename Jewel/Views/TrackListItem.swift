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
    var trackId: Int
    
    var body: some View {
        let albumArtist = self.wallet.slots[self.slotId].album?.attributes?.artistName ?? ""
        
        let trackListItem = Unwrap(wallet.slots[slotId].album?.relationships?.tracks.data?[trackId].attributes) { track in
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
                    if track.artistName != albumArtist {
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
        return trackListItem
    }
}

struct TrackListItem_Previews: PreviewProvider {
    static var previews: some View {
        TrackListItem(slotId: 1, trackId: 1)
    }
}
