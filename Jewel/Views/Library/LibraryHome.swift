//
//  Library.swift
//  Listen Later
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct LibraryHome: View {
  
  @EnvironmentObject var store: AppStore
  
  private var collections: [Collection] {
    store.state.library.collections
  }
  
  var body: some View {
    List {
      ForEach(collections) { collection in
        NavigationLink(destination: SharedCollection(collection: collection)) {
          VStack(alignment: .leading) {
            CollectionCard(collection: collection)
          }
        }
      }
      .onMove { (indexSet, index) in
        self.store.update(action: LibraryAction.moveCollection(from: indexSet, to: index))
      }
      .onDelete {
        self.store.update(action: LibraryAction.removeCollection(slotIndexes: $0))
      }
    }
    .navigationBarTitle("Shared Collections")
    .navigationBarItems(
      trailing: NavigationBarItemsTrailing()
    )
  }
}
