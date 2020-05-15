//
//  DiscTracklist.swift
//  Jewel
//
//  Created by Greg Hepworth on 06/05/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct DiscTrackList: View {
    
    @EnvironmentObject var userData: UserData
    var slotIndex: Int
    var discNumber: Int
    var withTitle: Bool
    
    var body: some View {

        let tracks = userData.activeCollection.slots[slotIndex].source?.album?.relationships?.tracks.data
        let discTracks = tracks?.filter { $0.attributes?.discNumber == discNumber }
        let albumArtist = userData.activeCollection.slots[slotIndex].source?.album?.attributes?.artistName
        
        let discTrackList = VStack(alignment: .leading) {
            if withTitle {
                Text("Disc \(discNumber)")
                    .fontWeight(.bold)
                    .padding(.vertical)
            }
            IfLet(discTracks) { discTracks in
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
                                if attributes.artistName != albumArtist {
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
        
        return discTrackList
    }
}

struct DiscTracklist_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        DiscTrackList(slotIndex: 0, discNumber: 1, withTitle: true).environmentObject(userData)
    }
}
