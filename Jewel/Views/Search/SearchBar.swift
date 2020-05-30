//
//  SearchBar.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
    
    @EnvironmentObject var store: AppStore
    
    @State private var searchTerm: String = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "magnifyingglass")
                TextField(
                    "Search Apple Music",
                    text: $searchTerm,
                    onCommit: {
                        self.store.update(action: SearchActions.search(term: self.searchTerm))
                }
                ).foregroundColor(.primary)
                    .keyboardType(.webSearch)
                Button(action: {
                    self.searchTerm = ""
                    self.store.update(action: SearchActions.removeSearchResults)
//                    self.searchProvider.results?.removeAll()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .opacity(searchTerm == "" ? 0 : 1)
                }
            }
            .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
            .foregroundColor(.secondary)
            .background(Color(.secondarySystemBackground))
            .cornerRadius(8.0)
        }
        .padding()
    }
}

struct SearchBar_Previews: PreviewProvider {
    static var previews: some View {
        SearchBar()
    }
}
