//
//  ReleaseDetailView.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct ReleaseDetailView: View {
    
    var title: String
    var artist: String
    var artwork: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Image(artwork)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .shadow(radius: 5)
            Text(title)
                .font(.title)
                .fontWeight(.bold)
                
            Text(artist)
                .font(.title)
            Spacer()
        }
        .padding(.all)
        .background(Image(artwork)
            .resizable()
            .scaledToFill()
            .brightness(0.4)
            .blur(radius: 20)
            .edgesIgnoringSafeArea(.all)
        )
        .statusBar(hidden: true)
    }
}

struct ReleaseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ReleaseDetailView(title: "My Album", artist: "My Artist", artwork: "fatoftheland")
    }
}
