//
//  Home.swift
//  Listen Later
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Home: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var receivedCollectionCued: Binding<Bool> {
    Binding (
      get: { self.app.state.library.cuedCollection != nil },
      set: { _ = $0 }
    )
  }
  
  var body: some View {
    ZStack {
      TabView(selection: $app.navigation.selectedTab) {
        OnRotation()
          .tabItem {
            Image(systemName: "music.house")
            Text("On Rotation")
        }
        .tag("onrotation")
        .environmentObject(self.app)
        CollectionLibrary()
          .tabItem {
            Image(systemName: "rectangle.on.rectangle.angled")
            Text("Collection Library")
        }
        .tag("library")
        .environmentObject(self.app)
      }
      .disabled(app.state.options.firstTimeRun)
      .alert(isPresented: receivedCollectionCued) {
        Alert(title: Text("Shared collection received."),
              message: Text("Would you like to add \"\(app.state.library.cuedCollection!.collectionName)\" by \"\(app.state.library.cuedCollection!.collectionCurator)\" to your Shared Library?"),
              primaryButton: .cancel(Text("Cancel")) {
                self.app.update(action: LibraryAction.uncueSharedCollection)
          },
              secondaryButton: .default(Text("Add").bold()) {
                self.app.navigation.selectedTab = "library"
                SharedCollectionManager.expandShareableCollection(shareableCollection: self.app.state.library.cuedCollection!)
                self.app.update(action: LibraryAction.uncueSharedCollection)
          })
      }
      .blur(radius: app.state.options.firstTimeRun ? 10 : 0)
      if app.state.options.firstTimeRun {
        Welcome()
      }
    }
    .onAppear {
      UITableView.appearance().separatorStyle = .none
    }
  }
}
