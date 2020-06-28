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
  
  let slotIndex: Int
  let collectionId: UUID
  @Binding var showing: Bool
  
  var body: some View {
    NavigationView {
      VStack{
        SearchBar()
        Spacer()
        SearchResults(slotIndex: slotIndex, collectionId: collectionId, showing: self.$showing)
      }
      .navigationBarTitle("Search")
      .navigationBarItems(
        leading:
        Button(action: {
          self.app.update(action: SearchAction.removeSearchResults)
          self.showing = false
        }) {
          Text("Close")
        }
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}
