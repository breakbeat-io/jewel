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
  
  let collection: Collection
  
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
            Image(systemName: "square.and.pencil")
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
