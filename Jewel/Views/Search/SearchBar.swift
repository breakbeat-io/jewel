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
      Image(systemName: "magnifyingglass")
      TextField(
        "Search releases",
        text: $searchTerm,
        onCommit: {
          if self.app.state.navigation.showDebugMenu {
            RecordStore.exampleSearch()
          } else {
            RecordStore.browse(for: self.searchTerm)
          }
      })
        .foregroundColor(.primary)
        .keyboardType(.webSearch)
      Button(action: {
        self.searchTerm = ""
        self.app.update(action: SearchAction.removeSearchResults)
      }) {
        Image(systemName: "xmark.circle.fill")
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
