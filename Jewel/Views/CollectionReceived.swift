//
//  CollectionReceived.swift
//  Listen Later
//
//  Created by Greg Hepworth on 26/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionReceived: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    Overlay(heading: "Shared collection received.",
            buttons: CollectionReceivedButtons()) {
              IfLet(app.state.library.cuedCollection) { cuedCollection in
                Text("Would you like to add \"\(cuedCollection.collectionName)\" by \"\(cuedCollection.collectionCurator)\" to your Shared Library?")
              }
    }
  }
}

struct CollectionReceivedButtons: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    HStack {
      Spacer()
      Button(action: {
        self.app.update(action: LibraryAction.uncueSharedCollection)
      }, label: {
        Text("Cancel")
      })
      Spacer()
      Button(action: {
        self.app.navigation.selectedTab = .library
        SharedCollectionManager.expandShareableCollection(shareableCollection: self.app.state.library.cuedCollection!)
        self.app.update(action: LibraryAction.uncueSharedCollection)
      }, label: {
        Text("Add")
      })
      Spacer()
    }
  }
}
