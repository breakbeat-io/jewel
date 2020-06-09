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
  
  @State private var isEditing: Bool = false
  
  private var selectedTab: Binding<String> {
    Binding (
      get: { self.store.state.library.userCollectionActive ? "user" : "shared" },
      set: { self.store.update(action: LibraryAction.userCollectionActive($0 == "user" ? true : false )) }
    )
  }
  private var receivedCollectionCued: Binding<Bool> {
    Binding (
      get: { self.store.state.library.cuedCollection != nil },
      set: { _ = $0 }
    )
  }
  
  var body: some View {
    ZStack {
      NavigationView {
        TabView(selection: selectedTab) {
          UserCollection(isEditing: self.$isEditing)
            .tabItem {
              Image(systemName: "music.house")
                .imageScale(.medium)
              Text(store.state.library.userCollection.name)
          }
          .tag("user")
          SharedCollections(isEditing: self.$isEditing)
            .tabItem {
              Image(systemName: "rectangle.on.rectangle.angled")
                .imageScale(.medium)
              Text("Collection Library")
          }
          .tag("shared")
        }
        .alert(isPresented: receivedCollectionCued) {
          Alert(title: Text("Shared collection received."),
                message: Text("Would you like to add \"\(store.state.library.cuedCollection!.collectionName)\" by \"\(store.state.library.cuedCollection!.collectionCurator)\" to your Shared Library?"),
                primaryButton: .cancel(Text("Cancel")) {
                  self.store.update(action: LibraryAction.uncueSharedCollection)
            },
                secondaryButton: .default(Text("Add").bold()) {
                  self.store.update(action: LibraryAction.userCollectionActive(false))
                  ShareLinkProvider.expandShareableCollection(shareableCollection: self.store.state.library.cuedCollection!)
                  self.store.update(action: LibraryAction.uncueSharedCollection)
            })
        }
        .navigationBarTitle(store.state.library.userCollectionActive ? self.store.state.library.userCollection.name : "Collection Library")
        .navigationBarItems(
          leading: UserCollectionButtons(),
          trailing: LibraryButtons(isEditing: self.$isEditing)
        )
        EmptyDetail()
      }
      .blur(radius: store.state.options.firstTimeRun ? 10 : 0)
      if store.state.options.firstTimeRun {
        Welcome()
      }
    }
    .onAppear {
      UITableView.appearance().separatorStyle = .none
    }
  }
}
