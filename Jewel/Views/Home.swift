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
      get: { self.store.state.library.recievedCollectionCued },
      set: { self.store.update(action: LibraryAction.setRecievedCollectioCued(cuedState: $0)) }
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
        Alert(title: Text("Shared collection received from \(store.state.library.recievedCollection?.curator ?? "a discerning curator")!"),
              message: Text("Would you like to add the Collection \(store.state.library.recievedCollection?.name ?? "") to your Shared Library?"),
              primaryButton: .cancel(Text("Cancel")) {
                self.store.update(action: LibraryAction.uncueRecievedCollection)
          },
              secondaryButton: .default(Text("Add").bold()) {
                self.store.update(action: LibraryAction.commitRecievedCollection)
          })
      }
    }
  }
}
