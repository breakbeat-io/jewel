//
//  CollectionSheet.swift
//  Listen Later
//
//  Created by Greg Hepworth on 25/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionSheet: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var collectionId: UUID {
    app.navigation.activeCollectionId
  }
  private var collection: Collection {
    if collectionId == app.state.library.onRotation.id {
      return app.state.library.onRotation
    } else {
      let collectionIndex = app.state.library.collections.firstIndex(where: { $0.id == collectionId })!
      return app.state.library.collections[collectionIndex]
    }
  }
  
  var body: some View {
    NavigationView {
      CollectionDetail(collection: collection)
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(
          leading: Button(action: {
              self.app.navigation.showCollection = false
            }) {
              Text("Close")
            },
          trailing:
            CollectionActionButtons()
      )
    }
      .navigationViewStyle(StackNavigationViewStyle())
    .onDisappear {
      self.app.navigation.collectionIsEditing = false
    }
  }
  
}
