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
  
  var collection: CollectionState
  
  var body: some View {
    Rectangle()
      .foregroundColor(.clear)
      .background(
        CollectionArtworkComposite(collection: collection)
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
