//
//  ReleaseDetailView.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct ReleaseDetail: View {
    
   var release: Release
    
    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: release.artworkURL)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .shadow(radius: 5)
            Text(release.title)
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(.black)
                .lineLimit(1)
            Text(release.artist)
                .font(.title)
                .foregroundColor(.black)
                .lineLimit(1)
            Spacer()
            HStack {
                Spacer()
                PlaybackControls(playbackUrl: release.appleMusicShareURL)
                Spacer()
            }
            Spacer()
        }
        .padding(.all)
        .background(
            WebImage(url: release.artworkURL)
                .resizable()
                .scaledToFill()
                .brightness(0.4)
                .blur(radius: 20)
                .edgesIgnoringSafeArea(.all)
        )
    }
}

struct ReleaseDetailView_Previews: PreviewProvider {
    static let wallet = Wallet()
    
    static var previews: some View {
        ReleaseDetail(release: wallet.releases[0])
    }
}
