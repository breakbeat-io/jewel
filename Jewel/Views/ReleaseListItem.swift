//
//  Album.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct ReleaseListItem: View {
    
    var title: String
    var artist: String
    var artwork: String
    
    var body: some View {
        Rectangle()
        .foregroundColor(.clear)
        .background(
            Image(artwork)
                .renderingMode(.original)
                .resizable()
                .scaledToFill()
        )
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 4))
        .overlay(
            ReleaseMetadataOverlay(
                title: title,
                artist: artist
            ), alignment: .bottomLeading
        )
    }
}

struct Album_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseListItem(title: "The Fat Of The Land", artist: "The Prodigy", artwork: "fatoftheland")
    }
}
