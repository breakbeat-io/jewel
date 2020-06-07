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
  
  private var recievedCollectionCued: Binding<Bool> {
    Binding (
      get: { self.store.state.library.recievedCollection != nil },
      set: { _ = $0 }
    )
  }
  
  var body: some View {
    NavigationView {
      Group {
        if store.state.collection.active {
          CollectionHome()
        } else {
          LibraryHome()
        }
      }
      .alert(isPresented: recievedCollectionCued) {
        Alert(title: Text("Shared collection received from a discerning curator."),
              message: Text("Would you like to add the Collection to your Shared Library?"),
              primaryButton: .cancel(Text("Cancel")) {
                self.store.update(action: LibraryAction.uncueRecievedCollection)
          },
              secondaryButton: .default(Text("Add").bold()) {
                ShareLinkProvider.expandCollection(shareableCollection: self.store.state.library.recievedCollection!)
                self.store.update(action: CollectionAction.setActiveState(activeState: false))
          })
      }
    }
  }
}
