//
//  AlbumDetail.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import HMV

struct AlbumDetail: View {
    
    @EnvironmentObject var userData: UserData
    var slotId: Int
    
    var body: some View {
        
        VStack {
            VStack(alignment: .leading) {
                IfLet(userData.slots[slotId].album?.attributes) { attributes in
                    KFImage(attributes.artwork.url(forWidth: 1000))
                        .placeholder {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray)
                        }
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(4)
                        .shadow(radius: 4)
                    Text(attributes.name)
                        .fontWeight(.bold)
                        .font(.title)
                        .foregroundColor(.black)
                        .lineLimit(1)
                    Text(attributes.artistName)
                        .font(.title)
                        .foregroundColor(.black)
                        .lineLimit(1)
                }
            }
            IfLet(userData.slots[slotId].album?.attributes?.url) { url in
                HStack(alignment: .center) {
                    PlaybackLink(slotId: self.slotId)
                    .padding()
                }
            }
            IfLet(userData.slots[slotId].album) { album in
                AlbumTrackList(slotId: self.slotId)
            }
        }
        .padding()
        .background(
            IfLet(userData.slots[slotId].album?.attributes?.artwork) { artwork in
                KFImage(artwork.url(forWidth: 1000))
                .resizable()
                .scaledToFill()
                .brightness(0.4)
                .blur(radius: 20)
                .edgesIgnoringSafeArea(.all)
            }
        )
    }
}

struct AlbumDetail_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        AlbumDetail(slotId: 0).environmentObject(userData)
    }
}
