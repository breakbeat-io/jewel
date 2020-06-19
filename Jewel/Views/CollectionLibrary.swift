//
//  Library.swift
//  Listen Later
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionLibrary: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var collections: [Collection] {
    app.state.library.collections
  }
  
  var body: some View {
    NavigationView {
      Group {
        if collections.isEmpty {
          Text("Collections you have saved or that people have shared with you will appear here.")
            .multilineTextAlignment(.center)
            .foregroundColor(Color.secondary)
            .padding()
        } else {
          List(selection: $app.navigation.libraryEditSelection) {
            ForEach(collections) { collection in
              NavigationLink(destination: CollectionDetail(collectionId: collection.id)) {
                CollectionCard(collection: collection)
              }
            }
            .onMove { (indexSet, index) in
              self.app.update(action: LibraryAction.moveSharedCollection(from: indexSet, to: index))
            }
            .onDelete {
              self.app.update(action: LibraryAction.removeSharedCollection(slotIndexes: $0))
            }
          }
        }
      }
      .environment(\.editMode, .constant(self.app.navigation.libraryIsEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
      .navigationBarTitle("Collection Library")
      .navigationBarItems(
        leading:
          LibraryEditButtons()
          .padding(.vertical),
        trailing:
          HStack {
            AddCollectionButton()
              .padding(.trailing)
            LibraryOptionsButton()
          }
          .disabled(app.navigation.libraryIsEditing)
          .padding(.vertical)
      )
    }
  }
}
