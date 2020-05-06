//
//  AlbumTrackList.swift
//  Jewel
//
//  Created by Greg Hepworth on 24/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct AlbumTrackList: View {
    
    @EnvironmentObject var userData: UserData
    var slotId: Int
    
    var body: some View {
        
        VStack(alignment: .leading) {
            IfLet(userData.slots[slotId].album?.discCount()) { numberOfDiscs in
                ForEach(1..<numberOfDiscs + 1, id: \.self) {
                    DiscTrackList(slotId: self.slotId, discNumber: $0, withTitle: (numberOfDiscs > 1) ? true : false)
                }
            }
        }
    }
}

struct DiscTrackList: View {
    
    @EnvironmentObject var userData: UserData
    var slotId: Int
    var discNumber: Int
    var withTitle: Bool
    
    var body: some View {
        
        VStack(alignment: .leading) {
            if withTitle {
                Text("Disc \(discNumber)")
                    .fontWeight(.bold)
                    .padding(.vertical)
            }
            IfLet(self.userData.slots[self.slotId].album?.tracksForDisc(discNumber: discNumber)) { discTracks in
                ForEach(discTracks) { track in
                    HStack {
                        Text(String(track.attributes!.trackNumber))
                            .font(.footnote)
                            .frame(width: 20, alignment: .center)
                            .padding(.vertical)
                            .padding(.trailing)
                        VStack(alignment: .leading) {
                            Text(track.attributes!.name)
                                .font(.callout)
                                .fontWeight(.medium)
                                .lineLimit(1)
                            Text(track.attributes!.artistName)
                                .font(.callout)
                                .fontWeight(.light)
                                .opacity(0.7)
                                .lineLimit(1)
                        }
                        Spacer()
                        Text(track.attributes!.duration!)
                            .font(.footnote)
                            .opacity(0.7)
                    }
                }
            }
        }
    }
}

struct TrackList_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        AlbumTrackList(slotId: 0).environmentObject(userData)
    }
}
