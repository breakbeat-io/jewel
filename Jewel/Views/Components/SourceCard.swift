//
//  AlbumCard.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI

struct SourceCard: View {
  
  let slot: Slot
  
  let sourceName: String
  let sourceArtist: String
  var sourceArtwork: URL?
  
  @State private var showSourceDetail: Bool = false
  
  var body: some View {
    Button(action: {
      self.showSourceDetail.toggle()
    }) {
      Rectangle()
        .foregroundColor(.clear)
        .background(
          IfLet(sourceArtwork) { url in
            KFImage(url)
              .placeholder {
                RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                  .fill(Color(UIColor.secondarySystemBackground))
            }
            .renderingMode(.original)
            .resizable()
            .scaledToFill()
        })
        .cornerRadius(Constants.cardCornerRadius)
        .overlay(
          VStack(alignment: .leading) {
            Text(sourceName)
              .font(.callout)
              .fontWeight(.bold)
              .foregroundColor(.white)
              .padding(.top, 4)
              .padding(.horizontal, 6)
              .lineLimit(1)
            Text(sourceArtist)
              .font(.footnote)
              .foregroundColor(.white)
              .padding(.horizontal, 6)
              .padding(.bottom, 4)
              .lineLimit(1)
          }
          .background(Color.black.opacity(0.8))
          .cornerRadius(Constants.cardCornerRadius)
          .padding(4)
          , alignment: .bottomLeading)
        .shadow(radius: 3)
    }
    .sheet(isPresented: $showSourceDetail) {
      AlbumDetail(slot: self.slot)
    }
  }
}
