//
//  ItemView.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import HMV

struct AlbumCard: View {
    
    let album: Album
    
    private var attributes: AlbumAttributes? {
        album.attributes
    }
    
    var body: some View {
        Rectangle()
            .foregroundColor(.clear)
            .background(
                IfLet(attributes?.artwork) { artwork in
                    KFImage(artwork.url(forWidth: 1000))
                        .placeholder {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray)
                    }
                    .renderingMode(.original)
                    .resizable()
                    .scaledToFill()
            })
            .frame(height: 80)
            .cornerRadius(4)
            .overlay(
                VStack(alignment: .leading) {
                    IfLet(attributes) { attributes in
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
