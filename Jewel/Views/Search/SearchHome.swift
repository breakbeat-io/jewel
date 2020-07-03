//
//  Search.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct SearchHome: View {
  
  @EnvironmentObject private var app: AppEnvironment
  
  var body: some View {
    NavigationView {
      VStack{
        SearchBar()
        Spacer()
        SearchResults(collectionId: app.state.navigation.activeCollectionId!, slotIndex: app.state.navigation.activeSlotIndex)
      }
      .navigationBarTitle("Search")
      .navigationBarItems(
        leading:
        Button(action: {
          self.app.update(action: SearchAction.removeSearchResults)
          self.app.update(action: NavigationAction.showSearch(false))
        }) {
          Text("Close")
        }
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}
