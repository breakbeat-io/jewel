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

struct AlbumListItem: View {
    
    @EnvironmentObject var wallet: WalletViewModel
    var slotId: Int
    
    var body: some View {
        Rectangle()
        .foregroundColor(.clear)
        .background(
            Unwrap(wallet.slots[slotId].album?.attributes?.artwork.url(forWidth: 1000)) { artworkUrl in
                KFImage(artworkUrl)
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
            ReleaseMetadataOverlay(slotId: slotId
            ), alignment: .bottomLeading
        )
    }
}

struct ReleaseListItem_Previews: PreviewProvider {
    
    static let wallet = WalletViewModel()
    
    static var previews: some View {
        AlbumListItem(slotId: 0)
    }
}
