//
//  ReleaseMetadataOverlayView.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct ReleaseMetadataOverlay: View {
    
    let title: String
    let artist: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.callout)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.top, 4)
                .padding(.horizontal, 6)
                .lineLimit(1)
            Text(artist)
                .font(.footnote)
                .foregroundColor(.white)
                .padding(.horizontal, 6)
                .padding(.bottom, 4)
                .lineLimit(1)
        }
        .background(Color.black)
        .cornerRadius(2.0)
        .padding(4)
    }
}

struct ReleaseMetadataOverlayView_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseMetadataOverlay(title: "The Fat of the Land", artist: "The Prodigy")
    }
}
