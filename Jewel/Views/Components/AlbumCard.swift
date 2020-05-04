//
//  Album.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import HMV

struct AlbumCard: View {
    
    var album: Album
    
    var body: some View {
        Rectangle()
        .foregroundColor(.clear)
        .background(
            Unwrap(album.attributes?.artwork) { artwork in
                KFImage(artwork.url(forWidth: 1000))
                .placeholder {
                    RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray)
                }
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
            })
        .cornerRadius(4)
        .overlay(
            VStack(alignment: .leading) {
                Unwrap(album.attributes) { attributes in
                    Text(attributes.name)
                        .font(.callout)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.top, 4)
                        .padding(.horizontal, 6)
                        .lineLimit(1)
                    Text(attributes.artistName)
                        .font(.footnote)
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.bottom, 4)
                        .lineLimit(1)
                }
            }
            .background(Color.black)
            .cornerRadius(4)
            .padding(4)
        , alignment: .bottomLeading)
        .shadow(radius: 3)
    }
}

struct ReleaseListItem_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        AlbumCard(album: userData.slots[0].album!)
    }
}