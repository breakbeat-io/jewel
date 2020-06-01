//
//  AlbumCover.swift
//  Jewel
//
//  Created by Greg Hepworth on 30/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import HMV

struct AlbumCover: View {
    
    let album: Album
    
    private var attributes: AlbumAttributes? {
        album.attributes
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            IfLet(attributes) { attributes in
                KFImage(attributes.artwork.url(forWidth: 1000))
                    .placeholder {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color.gray)
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(4)
                .shadow(radius: 4)
                Group {
                    Text(attributes.name)
                        .fontWeight(.bold)
                    Text(attributes.artistName)
                }
                .font(.title)
                .lineLimit(1)
            }
        }
    }
}