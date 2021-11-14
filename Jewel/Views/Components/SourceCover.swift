//
//  NewAlbumCover.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct SourceCover: View {
  
  let sourceName: String
  let sourceArtist: String
  var sourceArtwork: URL?
  
  var body: some View {
    VStack(alignment: .leading) {
        // macCatalyst uses a fixed sized sheet regardless of window size, so
        // need to fix the frame size for the Image to avoid it consuming the
        // whole window, and then center it.
#if targetEnvironment(macCatalyst)
        HStack() {
          Spacer()
          AsyncImage(url: self.sourceArtwork) { image in
            image
              .resizable()
              .aspectRatio(contentMode: .fit)
          } placeholder: {
            ProgressView()
          }
          .frame(height: 300)
          .cornerRadius(4)
          .shadow(radius: 4)
          Spacer()
        }
#else
        AsyncImage(url: self.sourceArtwork) { image in
          image
            .resizable()
            .aspectRatio(contentMode: .fit)
        } placeholder: {
          ProgressView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .aspectRatio(1, contentMode: .fill)
        .cornerRadius(4)
        .shadow(radius: 4)
#endif
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
