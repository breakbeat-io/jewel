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
    Rectangle()
      .foregroundColor(.clear)
      .background(
        CardArtworkComposite(images: collectionArtwork)
    )
      .cornerRadius(4)
      .overlay(
        VStack(alignment: .leading) {
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
            .padding(.horizontal, 6)
            .padding(.bottom, 4)
            .lineLimit(1)
        }
        .background(Color.black)
        .cornerRadius(4)
        .padding(4)
        , alignment: .bottomLeading)
      .frame(height: 60)
      .shadow(radius: 3)
  }
}
