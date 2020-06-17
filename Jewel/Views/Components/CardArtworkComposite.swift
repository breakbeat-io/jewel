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
  
  let images: [URL]
  
  var body: some View {
    HStack {
      if images.count != 0 {
        ForEach(images, id: \.self) { image in
          Rectangle()
            .foregroundColor(.clear)
            .background(
              KFImage(image)
                .placeholder {
                  RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.secondarySystemBackground))
              }
              .resizable()
              .scaledToFill()
          )
            .clipped()
            .frame(height: Helpers.cardHeights.medium.rawValue * 3)
            .rotationEffect(.degrees(15))
        }
      } else {
        Rectangle()
          .foregroundColor(Color(UIColor.secondarySystemBackground))
      }
      
    }
  }
}
