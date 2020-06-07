//
//  AlbumCard.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct AlbumCard: View {
  
  let albumName: String
  let albumArtist: String
  var albumArtwork: URL?
  
  var body: some View {
    Rectangle()
      .foregroundColor(.clear)
      .background(
        IfLet(albumArtwork) { url in
          KFImage(url)
            .placeholder {
              RoundedRectangle(cornerRadius: 4)
                .fill(Color(UIColor.secondarySystemBackground))
          }
          .renderingMode(.original)
          .resizable()
          .scaledToFill()
      })
      .cornerRadius(4)
      .overlay(
        VStack(alignment: .leading) {
            Text(albumName)
              .font(.callout)
              .fontWeight(.bold)
              .foregroundColor(.white)
              .padding(.top, 4)
              .padding(.horizontal, 6)
              .lineLimit(1)
            Text(albumArtist)
              .font(.footnote)
              .foregroundColor(.white)
              .padding(.horizontal, 6)
              .padding(.bottom, 4)
              .lineLimit(1)
        }
        .background(Color.black)
        .cornerRadius(4)
        .padding(4)
        , alignment: .bottomLeading)
      .shadow(radius: 3)
  }
}
