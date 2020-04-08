//
//  Album.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct ReleaseView: View {
    
    var title: String
    var artist: String
    var artwork: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(artwork)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .cornerRadius(6)
                .overlay(
                    ReleaseMetadataOverlayView(
                        title: title,
                        artist: artist
                    ), alignment: .bottomLeading
                )
        }
    }
}

struct Album_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseView(title: "The Fat Of The Land", artist: "The Prodigy", artwork: "fatoftheland")
    }
}
