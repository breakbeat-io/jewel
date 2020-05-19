//
//  SearchBar.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import HMV

struct SearchBar: View {
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var searchProvider: SearchProvider
    @State private var searchTerm: String = ""
    
    var body: some View {
        
        VStack(alignment: .leading) {
            Text("Search")
                .font(.title)
                .fontWeight(.bold)
            HStack {
                HStack {
                    Image(systemName: "magnifyingglass")
                    TextField(
                        "Search Apple Music",
                        text: $searchTerm,
                        onCommit: {
                            if self.userData.preferences.debugMode {
                                self.searchProvider.exampleSearch()
                            } else {
                                self.searchProvider.search(searchTerm: self.searchTerm)
                            }
                    }
                    ).foregroundColor(.primary)
                        .keyboardType(.webSearch)
                    Button(action: {
                        self.searchTerm = ""
                        self.searchProvider.results?.removeAll()
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
        }
        .padding()
    }
}


struct SearchBar_Previews: PreviewProvider {
    
    static var previews: some View {
        SearchBar()
    }
}
