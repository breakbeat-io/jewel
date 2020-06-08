//
//  Library.swift
//  Listen Later
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct SharedCollectionsHome: View {
  
  @EnvironmentObject var store: AppStore
  
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
        List {
          ForEach(collections) { collection in
            NavigationLink(destination: SharedCollectionsList(collection: collection)) {
              VStack(alignment: .leading) {
                CollectionCard(collection: collection)
              }
            }
          }
          .onMove { (indexSet, index) in
            self.store.update(action: LibraryAction.moveSharedCollection(from: indexSet, to: index))
          }
          .onDelete {
            self.store.update(action: LibraryAction.removeSharedCollection(slotIndexes: $0))
          }
        }
      }
    }
    .navigationBarTitle("Shared Collections")
    .navigationBarItems(
      trailing: NavigationBarItemsTrailing()
    )
  }
}
