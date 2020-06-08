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
  
  @Environment(\.presentationMode) var presentationMode
  
  @EnvironmentObject var store: AppStore
  
  var slotIndex: Int
  @Binding var showing: Bool
  
  private var searchResults: [Album]? {
    store.state.search.results
  }
  
  var body: some View {
    IfLet(searchResults) { albums in
      List(0..<albums.count, id: \.self) { i in
        IfLet(albums[i].attributes) { result in
          HStack {
            KFImage(result.artwork.url(forWidth: 50))
              .placeholder {
                RoundedRectangle(cornerRadius: 4)
                  .fill(Color(UIColor.secondarySystemBackground))
            }
            .renderingMode(.original)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .cornerRadius(4)
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
              RecordStore.purchase(album: albums[i].id, forSlot: self.slotIndex, inCollection: self.store.state.library.userCollection.id)
              self.store.update(action: SearchAction.removeSearchResults)
              self.showing = false
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
