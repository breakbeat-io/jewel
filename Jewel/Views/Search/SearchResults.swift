//
//  SearchResults.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import HMV

struct SearchResults: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  let collectionId: UUID
  let slotIndex: Int
  
  private var searchResults: [AppleMusicAlbum]? {
    app.state.search.results
  }
  
  var body: some View {
    IfLet(searchResults) { appleMusicAlbums in
      List(0..<appleMusicAlbums.count, id: \.self) { i in
        IfLet(appleMusicAlbums[i].attributes) { result in
          HStack {
            KFImage(result.artwork.url(forWidth: 50))
              .placeholder {
                RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                  .fill(Color(UIColor.secondarySystemBackground))
            }
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(Constants.cardCornerRadius)
            .frame(width: 50)
            VStack(alignment: .leading) {
              Text(result.name)
                .font(.headline)
                .lineLimit(1)
              Text(result.artistName)
                .font(.subheadline)
                .lineLimit(1)
            }
            Spacer()
            Button(action: {
              RecordStore.purchase(album: appleMusicAlbums[i].id, forSlot: self.slotIndex, inCollection: self.collectionId)
              self.app.update(action: SearchAction.removeSearchResults)
              self.app.update(action: NavigationAction.showSearch(false))
            }, label:{
              Image(systemName: "plus.circle")
                .padding()
            })
          }
        }
      }
    }
  }
}
