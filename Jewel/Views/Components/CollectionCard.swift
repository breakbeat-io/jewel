//
//  CollectionCard.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionCard: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  let collection: Collection
  
  private var collectionArtwork: [URL] {
    var artworkUrls = [URL]()
    for slot in collection.slots {
      if let artworkUrl = slot.album?.artwork?.url(width: 1000, height: 1000) {
        artworkUrls.append(artworkUrl)
      }
    }
    return artworkUrls
  }
  
  var body: some View {
    Button {
      self.app.update(action: NavigationAction.setActiveCollectionId(collectionId: self.collection.id))
      self.app.update(action: NavigationAction.showCollection(true))
    } label: {
      ZStack(alignment: .bottom) {
        Rectangle()
          .foregroundColor(.clear)
          .background(
            CardArtworkComposite(images: collectionArtwork)
          )
          .cornerRadius(Constants.cardCornerRadius)
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
          .cornerRadius(Constants.cardCornerRadius)
          Spacer()
          if collection.type == .userCollection {
            Image(systemName: "person.circle")
              .padding(4)
              .foregroundColor(Color.white.opacity(0.8))
          }
        }
        .padding(4)
      }
    }
  }
}
