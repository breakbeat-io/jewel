//
//  SearchResultsList.swift
//  Jewel
//
//  Created by Greg Hepworth on 24/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import HMV

struct SearchResultsList: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var searchProvider: SearchProvider
    var slotIndex: Int
    
    var searchResults: [Album]? {
        searchProvider.results
    }
    
    var body: some View {
        IfLet(searchResults) { results in
            List(0..<results.count, id: \.self) { i in
                IfLet(results[i].attributes) { resultAttributes in
                    HStack {
                        KFImage(resultAttributes.artwork.url(forWidth: 50))
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
                            Text(resultAttributes.name)
                                .font(.headline)
                                .lineLimit(1)
                            Text(resultAttributes.artistName)
                                .font(.subheadline)
                                .lineLimit(1)
                        }
                        Spacer()
                        Button(action: {
                            self.userData.addContentToSlot(contentId: results[i].id, collection: self.userData.activeCollection, slotIndex: self.slotIndex)
                            self.presentationMode.wrappedValue.dismiss()
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
