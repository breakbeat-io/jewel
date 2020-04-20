//
//  Album.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import HMV

struct ReleaseListItem: View {
    
    var release: Release
    
    var body: some View {
        Rectangle()
        .foregroundColor(.clear)
        .background(
            WebImage(url: URL(string: release.artworkURL))
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
        )
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(
            ReleaseMetadataOverlay(
                title: release.title,
                artist: release.artist
            ), alignment: .bottomLeading
        )
    }
}

struct Album_Previews: PreviewProvider {
    
    static let wallet = Wallet()
    
    static var previews: some View {
        ReleaseListItem(release: wallet.releases[0])
    }
}
