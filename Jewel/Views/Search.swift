//
//  Search.swift
//  Jewel
//
//  Created by Greg Hepworth on 23/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import HMV

struct Search: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var wallet: WalletViewModel
    @State private var searchTerm: String = ""
    @State private var searchResults: [Album]?
    @State private var showingAlert = false
    var slotId: Int
    
    func search() {
        if let developerToken = Bundle.main.infoDictionary?["APPLE_MUSIC_API_TOKEN"] as? String {
            let hmv = HMV(storefront: .unitedKingdom, developerToken: developerToken)

            hmv.search(term: searchTerm, limit: 20, types: [.albums]) { results, error in
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
                        .fontWeight(.bold)
                }
                .padding()
                Spacer()
                Button(action: {
                    self.showingAlert = true
                }) {
                    Image(systemName: "square.and.arrow.down.on.square")
                        .padding()
                }
                .padding()
            }
            TextField("Search Apple Music", text: $searchTerm, onCommit: search)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
            if searchResults != nil {
                SearchResultsList(searchResults: $searchResults, slotId: slotId).environmentObject(wallet)
            }
            Spacer()
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Do you want to load our recommendations?"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .default(Text("Load").bold()) {
                    self.wallet.loadRecommendations()
                })
        }
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search(slotId: 1)
    }
}
