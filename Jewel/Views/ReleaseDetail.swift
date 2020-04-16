//
//  ReleaseDetailView.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import HMV

struct ReleaseDetail: View {
    
   var release: Release
    
    var body: some View {
        VStack(alignment: .leading) {
            release.artwork
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .shadow(radius: 5)
            Text(release.title)
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(1)
            Text(release.artist)
                .font(.title)
                .lineLimit(1)
            Spacer()
            PlaybackControls()
        }
        .padding(.all)
        .background(release.artwork
            .resizable()
            .scaledToFill()
            .brightness(0.4)
            .blur(radius: 20)
            .edgesIgnoringSafeArea(.all)
        )
    }
}

struct ReleaseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseDetail(release: releasesData[0])
    }
}
