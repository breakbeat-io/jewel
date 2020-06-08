//
//  Library.swift
//  Listen Later
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct SharedCollections: View {
  
  @EnvironmentObject var store: AppStore
  
  @Binding var isEditing: Bool
  
  private var collections: [Collection] {
    store.state.library.sharedCollections
  }
  
  var body: some View {
    Group {
      if collections.count == 0 {
        Text("Collections you have saved or people have shared with you will appear here.")
          .multilineTextAlignment(.center)
          .foregroundColor(Color.secondary)
      } else {
        VStack {
          List {
            ForEach(collections) { collection in
              NavigationLink(destination: SharedCollectionsList(collection: collection)) {
                VStack(alignment: .leading) {
                  CollectionCard(collection: collection)
                }
              }
            }
              // here set isediting based on whether the
              .onMove { (indexSet, index) in
                self.store.update(action: LibraryAction.moveSharedCollection(from: indexSet, to: index))
            }
            .onDelete {
              self.store.update(action: LibraryAction.removeSharedCollection(slotIndexes: $0))
            }
          }
          .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
        }
      }
    }
    .onAppear {
      self.isEditing = false
    }
  }
}
