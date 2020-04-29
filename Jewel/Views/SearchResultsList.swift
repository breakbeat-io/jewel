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
        
        let searchResultsList = Unwrap(searchResults) { albums in
            List(0..<albums.count, id: \.self) { i in
                Button(action: {
                    self.wallet.addAlbumToSlot(albumId: albums[i].id, slotId: self.slotId)
                    self.presentationMode.wrappedValue.dismiss()
                }, label: {
                    Unwrap(albums[i].attributes) { album in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(album.artistName)
                                    .font(.headline)
                                    .lineLimit(1)
                                Text(album.name)
                                    .font(.subheadline)
                                    .lineLimit(1)
                            }
                            Spacer()
                            KFImage(album.artwork.url(forWidth: 50))
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
                    }
                })
            }
        }
        return searchResultsList
    }
}

//struct SearchResultsList_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultsList()
//    }
//}
