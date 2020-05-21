//
//  DiscTracklist.swift
//  Jewel
//
//  Created by Greg Hepworth on 06/05/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import HMV

struct DiscTrackList: View {
    
    @EnvironmentObject var userData: UserData
    
    var slotIndex: Int
    var discNumber: Int
    var withTitle: Bool
    private var albumArtist: String? {
        userData.activeCollection.slots[slotIndex].source?.content?.attributes?.artistName
    }
    private var discTracks: [Track]? {
        userData.activeCollection.slots[slotIndex].source?.content?.relationships?.tracks.data?.filter { $0.attributes?.discNumber == discNumber }
    }
    
    var body: some View {
        IfLet(discTracks) { discTracks in
            VStack(alignment: .leading) {
                if self.withTitle {
                    Text("Disc \(self.discNumber)")
                        .fontWeight(.bold)
                        .padding(.vertical)
                }
                ForEach(discTracks) { track in
                    IfLet(track.attributes) { attributes in
                        HStack {
                            Text(String(attributes.trackNumber))
                                .font(.footnote)
                                .frame(width: 20, alignment: .center)
                                .padding(.vertical)
                                .padding(.trailing)
                            VStack(alignment: .leading) {
                                Text(attributes.name)
                                    .font(.callout)
                                    .fontWeight(.medium)
                                    .lineLimit(1)
                                if attributes.artistName != self.albumArtist {
                                    Text(attributes.artistName)
                                        .font(.callout)
                                        .fontWeight(.light)
                                        .opacity(0.7)
                                        .lineLimit(1)
                                }
                            }
                            Spacer()
                            IfLet(attributes.duration) { duration in
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
}

