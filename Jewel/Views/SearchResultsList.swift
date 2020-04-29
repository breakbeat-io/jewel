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
    @EnvironmentObject var wallet: WalletViewModel
    @EnvironmentObject var searchProvider: SearchProvider
    
    var slotId: Int
    
    var body: some View {
        
        let searchResults = searchProvider.results
        
        let searchResultsList = List(0..<searchResults!.count, id: \.self) { i in
            Button(action: {
                self.wallet.addAlbumToSlot(albumId: searchResults![i].id, slotId: self.slotId)
                self.presentationMode.wrappedValue.dismiss()
            }, label: {
                HStack {
                    VStack(alignment: .leading) {
                        Text(searchResults![i].attributes!.artistName)
                            .font(.headline)
                            .lineLimit(1)
                        Text(searchResults![i].attributes!.name)
                            .font(.subheadline)
                            .lineLimit(1)
                    }
                    Spacer()
                    KFImage(searchResults![i].attributes!.artwork.url(forWidth: 50))
                        .placeholder {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color.gray)
                        }
                        .renderingMode(.original)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(4)
                        .frame(width: 50)
                }
            })
        }
        
        return searchResultsList
    }
}

//struct SearchResultsList_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultsList()
//    }
//}
