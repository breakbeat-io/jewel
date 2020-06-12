//
//  CollectionCard.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct CollectionCard: View {
  
  let collection: Collection
  
  private var collectionArtwork: [URL] {
    var artworkUrls = [URL]()
    for slot in collection.slots {
      if let artworkUrl = slot.album?.attributes?.artwork.url(forWidth: 1000) {
        artworkUrls.append(artworkUrl)
      }
    }
    return artworkUrls
  }
  
  var body: some View {
    ZStack(alignment: .bottom) {
      Rectangle()
        .foregroundColor(.clear)
        .background(
          CardArtworkComposite(images: collectionArtwork)
      )
        .cornerRadius(4)
        .frame(height: Helpers.cardHeights.medium.rawValue)
        .shadow(radius: 3)
      HStack(alignment: .bottom) {
        VStack(alignment: .leading, spacing: 0) {
          Text(collection.name)
            .font(.callout)
            .fontWeight(.bold)
            .foregroundColor(.white)
            .padding(.top, 4)
            .padding(.horizontal, 6)
            .lineLimit(1)
          Text(collection.curator)
            .font(.footnote)
            .foregroundColor(.white)
            .lineLimit(1)
            .padding(.horizontal, 6)
            .padding(.bottom, 4)
        }
        .background(Color.black.opacity(0.8))
        .cornerRadius(4)
        Spacer()
        if collection.type == .userCollection {
          Image(systemName: "person.circle")
            .padding(4)
            .foregroundColor(Color.black.opacity(0.8))
        }
      }
      .padding(4)
    }
  }
}
