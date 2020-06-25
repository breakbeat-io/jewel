//
//  NewAlbumCover.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct SourceCover: View {
  
  let sourceName: String
  let sourceArtist: String
  var sourceArtwork: URL?
  
  var body: some View {
    VStack(alignment: .leading) {
      IfLet(sourceArtwork) { url in
        KFImage(self.sourceArtwork)
          .placeholder {
            RoundedRectangle(cornerRadius: 4)
              .fill(Color(UIColor.secondarySystemBackground))
        }
        .resizable()
        .aspectRatio(contentMode: .fit)
        .cornerRadius(4)
        .shadow(radius: 4)
      }
      Group {
        Text(sourceName)
          .fontWeight(.bold)
        Text(sourceArtist)
      }
      .font(.title)
      .lineLimit(1)
    }
  }
}
