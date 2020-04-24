//
//  SearchResultsList.swift
//  Jewel
//
//  Created by Greg Hepworth on 24/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import HMV

struct SearchResultsList: View {
    
    @Binding var searchResults: [Album]?
    
    var body: some View {
        List(0...self.searchResults!.count - 1, id: \.self) { i in
            HStack {
                VStack(alignment: .leading) {
                    Text(self.searchResults![i].attributes!.artistName)
                        .font(.headline)
                    Text(self.searchResults![i].attributes!.name)
                        .font(.subheadline)
                }
                Spacer()
                WebImage(url: self.searchResults![i].attributes!.artwork.url(forWidth: 50))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .frame(width: 50)
            }
        }
    }
}

//struct SearchResultsList_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchResultsList()
//    }
//}
