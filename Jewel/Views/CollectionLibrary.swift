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
  
  @State var isEditing = false
  @State var selections = Set<UUID>()
  
  private var collections: [Collection] {
    app.state.library.collections
  }
  
  var body: some View {
    NavigationView {
      Group {
        if collections.count == 0 {
          Text("Collections you have saved or that people have shared with you will appear here.")
            .multilineTextAlignment(.center)
            .foregroundColor(Color.secondary)
            .padding()
        } else {
          List(selection: $selections) {
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
      .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
      .navigationBarTitle("Collection Library")
      .navigationBarItems(
        leading:
        HStack {
          if self.isEditing {
            Button(action: {
              self.app.update(action: LibraryAction.removeSharedCollections(collectionIds: self.selections))
              self.isEditing.toggle()
              self.selections = Set<UUID>()
            }) {
              Image(systemName: "trash")
            }
            .padding(.trailing)
            Button(action: {
              self.isEditing.toggle()
            }) {
              Text("Done")
            }
          }
        }
        .padding(.vertical),
        trailing:
        HStack {
          AddCollectionButton()
            .padding(.trailing)
          LibraryOptionsButton(editMode: self.$isEditing)
        }
        .padding(.vertical)
      )
    }
  }
}
