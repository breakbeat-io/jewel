//
//  TrackListItem.swift
//  Jewel
//
//  Created by Greg Hepworth on 28/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import HMV

struct TrackListItem: View {
    
    var track: Track
    var albumArtist: String
    
    var body: some View {
        Unwrap(track.attributes) { trackAttributes in
            HStack {
                Text(String(trackAttributes.trackNumber))
                    .font(.footnote)
                    .frame(width: 20, alignment: .center)
                    .padding(.vertical)
                    .padding(.trailing)
                VStack(alignment: .leading) {
                    Text(trackAttributes.name)
                        .font(.callout)
                        .fontWeight(.medium)
                        .lineLimit(1)
                    if trackAttributes.artistName != self.albumArtist {
                        Text(trackAttributes.artistName)
                            .font(.callout)
                            .fontWeight(.light)
                            .opacity(0.7)
                            .lineLimit(1)
                    }
                }
                Spacer()
                Unwrap(trackAttributes.duration) { duration in
                    Text(duration)
                        .font(.footnote)
                        .opacity(0.7)
                }
            }
        }
    }
}

struct TrackListItem_Previews: PreviewProvider {
    static let userData = UserData()
    
    static var previews: some View {
        TrackListItem(track: (userData.slots[1].album?.relationships?.tracks.data?[1])!, albumArtist: (userData.slots[1].album?.attributes?.artistName)!)
    }
}
