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
    
    @Binding var showing: Bool
    
    private var searchResults: [Album]? {
        store.state.search.results
    }
    
    var body: some View {
        IfLet(searchResults) { results in
            List(0..<results.count, id: \.self) { i in
                IfLet(results[i].attributes) { result in
                    HStack {
                        KFImage(result.artwork.url(forWidth: 50))
                            .placeholder {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray)
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
                            self.store.update(action: CollectionAction.fetchAndAddAlbum(albumId: results[i].id))
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
