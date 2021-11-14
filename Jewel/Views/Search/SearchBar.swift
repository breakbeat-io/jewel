//
//  SearchBar.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct SearchBar: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  @State private var searchTerm: String = ""
  
  var body: some View {
    HStack {
      Text(Image(systemName: "magnifyingglass"))
      TextField(
        "Search music",
        text: $searchTerm,
        onCommit: {
          if app.state.navigation.showDebugMenu {
//            RecordStore.exampleSearch()
          } else {
            Task {
              app.update(action: NavigationAction.gettingSearchResults(true))
              async let searchResults = RecordStore.search(for: searchTerm)
              try? await app.update(action: SearchAction.populateSearchResults(results: searchResults))
              app.update(action: NavigationAction.gettingSearchResults(false))
            }
          }
      })
        .foregroundColor(.primary)
        .keyboardType(.webSearch)
      Button {
        searchTerm = ""
        app.update(action: SearchAction.removeSearchResults)
      } label: {
        Text(Image(systemName: "xmark.circle.fill"))
          .opacity(searchTerm == "" ? 0 : 1)
      }
    }
    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
    .foregroundColor(.secondary)
    .background(Color(.secondarySystemBackground))
    .cornerRadius(8.0)
    .padding()
  }
}
