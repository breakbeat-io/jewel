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
    VStack {
      HStack {
        Button(action: {
          self.app.navigation.showCollection = false
        }) {
          Text("Close")
        }
        Spacer()
        if app.navigation.collectionIsEditing {
          Button(action: {
            self.app.update(action: LibraryAction.removeSourcesFromCollection(sourceIds: self.app.navigation.collectionEditSelection, collectionId: self.collection.id))
              self.app.navigation.collectionIsEditing = false
              self.app.navigation.collectionEditSelection.removeAll()
          }) {
            Image(systemName: "trash")
          }
          Button(action: {
            self.app.navigation.collectionIsEditing.toggle()
          }) {
            Image(systemName: "checkmark")
          }
        } else {
          Button(action: {
            self.app.navigation.showCollectionOptions.toggle()
          }) {
            Image(systemName: "ellipsis")
          }
          .sheet(isPresented: $app.navigation.showCollectionOptions) {
            CollectionOptions()
                .environmentObject(self.app)
          }
        }
      }
      .padding([.top, .horizontal])
      CollectionDetail(collection: collection)
    }
    .onDisappear {
      self.app.navigation.collectionIsEditing = false
    }
  }
  
}
