//
//  ReleaseDetailView.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import HMV

struct ReleaseDetail: View {
    
   var release: Release
    
    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: URL(string: release.artworkURL))
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
            HStack {
                Spacer()
                //TODO: create the <URL> in here and pass it in rather than as a String, then do an `if` on whether the URL is nil or not.
                PlaybackControls(playbackUrl: release.appleMusicShareURL)
                Spacer()
            }
            Spacer()
        }
        .padding(.all)
        .background(
            WebImage(url: URL(string: release.artworkURL))
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
