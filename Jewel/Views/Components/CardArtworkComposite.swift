//
//  CollectionArtworkComposite.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct CardArtworkComposite: View {
  
  var images: [URL]
  
  var body: some View {
    HStack {
      ForEach(images, id: \.self) { image in
        Rectangle()
          .foregroundColor(.clear)
          .background(
            KFImage(image)
              .placeholder {
                RoundedRectangle(cornerRadius: 4)
                  .fill(Color.secondary)
            }
            .resizable()
            .scaledToFill()
        )
          .clipped()
          .frame(height: 120)
          .rotationEffect(.degrees(15))
      }
    }
  }
}
