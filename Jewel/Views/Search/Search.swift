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
    
    @EnvironmentObject var searchProvider: SearchProvider
    
    @State private var showCancelButton: Bool = false
    
    private var searchResults: [Album]? {
        searchProvider.results
    }
    
    var slotIndex: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
            }.padding()
            SearchBar()
            IfLet(searchResults) { results in
                SearchResultsList(
                    slotIndex: self.slotIndex
                )
            }
            Spacer()
        }
        .onDisappear(perform: {
            self.searchProvider.results?.removeAll()
        })
    }
}
