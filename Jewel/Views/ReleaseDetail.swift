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
    
   var albumAttributes: AlbumAttributes
    
    var body: some View {
        VStack(alignment: .leading) {
            WebImage(url: albumAttributes.artwork.url(forWidth: 1000))
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .shadow(radius: 5)
            Text(albumAttributes.name)
                .fontWeight(.bold)
                .font(.title)
                .foregroundColor(.black)
                .lineLimit(1)
            Text(albumAttributes.artistName)
                .font(.title)
                .foregroundColor(.black)
                .lineLimit(1)
            Spacer()
            HStack {
                Spacer()
                PlaybackControls(playbackUrl: albumAttributes.url)
                Spacer()
            }
            Spacer()
        }
        .padding(.all)
        .background(
            WebImage(url: albumAttributes.artwork.url(forWidth: 1000))
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
        ReleaseDetail(albumAttributes: (wallet.slots[0].album?.attributes)!)
    }
}
