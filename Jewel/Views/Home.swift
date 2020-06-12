//
//  Home.swift
//  Listen Later
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Home: View {
  
  @EnvironmentObject var environment: AppEnvironment
  
  @State private var isEditing: Bool = false
  
  private var selectedTab: Binding<String> {
    Binding (
      get: { self.environment.state.library.userCollectionActive ? "user" : "shared" },
      set: { self.environment.update(action: LibraryAction.userCollectionActive($0 == "user" ? true : false )) }
    )
  }
  private var receivedCollectionCued: Binding<Bool> {
    Binding (
      get: { self.environment.state.library.cuedCollection != nil },
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
              Text("On Rotation")
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
                message: Text("Would you like to add \"\(environment.state.library.cuedCollection!.collectionName)\" by \"\(environment.state.library.cuedCollection!.collectionCurator)\" to your Shared Library?"),
                primaryButton: .cancel(Text("Cancel")) {
                  self.environment.update(action: LibraryAction.uncueSharedCollection)
            },
                secondaryButton: .default(Text("Add").bold()) {
                  self.environment.update(action: LibraryAction.userCollectionActive(false))
                  SharedCollectionManager.expandShareableCollection(shareableCollection: self.environment.state.library.cuedCollection!)
                  self.environment.update(action: LibraryAction.uncueSharedCollection)
            })
        }
        .navigationBarTitle(environment.state.library.userCollectionActive ? self.environment.state.library.userCollection.name : "Collection Library")
        .navigationBarItems(
          leading: UserCollectionButtons(),
          trailing: LibraryButtons(isEditing: self.$isEditing)
        )
        EmptyDetail()
      }
      .blur(radius: environment.state.options.firstTimeRun ? 10 : 0)
      if environment.state.options.firstTimeRun {
        Welcome()
      }
    }
    .onAppear {
      UITableView.appearance().separatorStyle = .none
    }
  }
}
