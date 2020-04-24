//
//  Search.swift
//  Jewel
//
//  Created by Greg Hepworth on 23/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI
import HMV

struct Search: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var wallet: Wallet
    @State var searchTerm: String = ""
    @State var searchResults: [Album]?
    
    func search() {
        if let developerToken = Bundle.main.infoDictionary?["APPLE_MUSIC_API_TOKEN"] as? String {
            let hmv = HMV(storefront: .unitedKingdom, developerToken: developerToken)

            hmv.search(term: searchTerm, types: [.albums]) { results, error in
              DispatchQueue.main.async {
                self.searchResults = results?.albums?.data
              }
            }
        }
    }

    
    var body: some View {
        
        VStack(alignment: .leading) {
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")       
                }
                .padding()
                Spacer()
            }
            TextField("Search Apple Music", text: $searchTerm, onCommit: search)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            if searchResults != nil {
                SearchResultsList(searchResults: $searchResults).environmentObject(wallet)
            }
            Spacer()
        }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search()
    }
}
