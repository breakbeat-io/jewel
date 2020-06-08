//
//  Home.swift
//  Listen Later
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Home: View {
  
  @EnvironmentObject var store: AppStore
  
  private var receivedCollectionCued: Binding<Bool> {
    Binding (
      get: { self.store.state.library.cuedCollection != nil },
      set: { _ = $0 }
    )
  }
  
  var body: some View {
    NavigationView {
      Group {
        if store.state.library.userCollectionActive {
          UserCollection()
        } else {
          SharedCollections()
        }
      }
      .alert(isPresented: receivedCollectionCued) {
        Alert(title: Text("Shared collection received."),
              message: Text("Would you like to add \"\(store.state.library.cuedCollection!.collectionName)\" by \"\(store.state.library.cuedCollection!.collectionCurator)\" to your Shared Library?"),
              primaryButton: .cancel(Text("Cancel")) {
                self.store.update(action: LibraryAction.uncueSharedCollection)
          },
              secondaryButton: .default(Text("Add").bold()) {
                self.store.update(action: LibraryAction.setActiveState(activeState: false))
                ShareLinkProvider.expandShareableCollection(shareableCollection: self.store.state.library.cuedCollection!)
                self.store.update(action: LibraryAction.uncueSharedCollection)
          })
      }
    }
  }
}
