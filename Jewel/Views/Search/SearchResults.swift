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
    
    @EnvironmentObject var store: AppStore
    
    private var searchResults: [Album]? {
        store.state.search.results
    }
    
    var body: some View {
        IfLet(searchResults) { results in
            List(0..<results.count, id: \.self) { i in
                Text("There are some results")
//                IfLet(results[i].attributes) { result in
//                    HStack {
//                        KFImage(result.artwork.url(forWidth: 50))
//                            .placeholder {
//                                RoundedRectangle(cornerRadius: 4)
//                                    .fill(Color.gray)
//                        }
//                        .renderingMode(.original)
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .cornerRadius(4)
//                        .frame(width: 50)
//                        VStack(alignment: .leading) {
//                            Text(result.name)
//                                .font(.headline)
//                                .lineLimit(1)
//                            Text(result.artistName)
//                                .font(.subheadline)
//                                .lineLimit(1)
//                        }
//                        Spacer()
//                        Button(action: {
//                            self.collections.addContentToSlot(contentId: results[i].id,
//                                                           collection: self.collections.userCollection,
//                                                           slotIndex: self.slotIndex)
//                            self.presentationMode.wrappedValue.dismiss()
//                        }, label:{
//                            Image(systemName: "plus.circle")
//                                .padding()
//                        })
//                    }
//                }
            }
        }
    }
}

struct SearchResults_Previews: PreviewProvider {
    static var previews: some View {
        SearchResults()
    }
}
