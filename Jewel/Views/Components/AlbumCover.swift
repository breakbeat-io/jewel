//
//  AlbumCover.swift
//  Jewel
//
//  Created by Greg Hepworth on 07/05/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import HMV

struct AlbumCover: View {
    
    @EnvironmentObject var userData: UserData
    
    var slotIndex: Int
    private var attributes: AlbumAttributes? {
        userData.activeCollection.slots[slotIndex].source?.content?.attributes
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

