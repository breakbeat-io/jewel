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
        Spacer()
        if app.navigation.listIsEditing {
          Button(action: {
            self.app.update(action: LibraryAction.removeSourcesFromCollection(sourceIds: self.app.navigation.collectionEditSelection, collectionId: self.collection.id))
              self.app.navigation.listIsEditing = false
              self.app.navigation.collectionEditSelection.removeAll()
          }) {
            Image(systemName: "trash")
          }
          .padding(.trailing)
          Button(action: {
            self.app.navigation.listIsEditing.toggle()
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
            CollectionOptions(collectionId: self.collection.id)
                .environmentObject(self.app)
          }
        }
      }
      .padding()
//      Rectangle()
//        .frame(height: 1.0, alignment: .bottom)
//        .foregroundColor(Color(UIColor.systemFill))
      CollectionDetail(collection: collection)
    }
  }
  
}
