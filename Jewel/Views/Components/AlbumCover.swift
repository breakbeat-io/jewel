//
//  NewAlbumCover.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct AlbumCover: View {
  
  var albumName: String
  var albumArtist: String
  var albumArtwork: URL?
  
  var body: some View {
    VStack(alignment: .leading) {
      IfLet(albumArtwork) { url in
        KFImage(self.albumArtwork)
          .placeholder {
            RoundedRectangle(cornerRadius: 4)
              .fill(Color.gray)
        }
        .resizable()
        .aspectRatio(contentMode: .fit)
        .cornerRadius(4)
        .shadow(radius: 4)
      }
      Group {
        Text(albumName)
          .fontWeight(.bold)
        Text(albumArtist)
      }
      .font(.title)
      .lineLimit(1)
    }
  }
}
