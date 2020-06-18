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
  
  @State private var selectedTab = "onrotation"
  
  private var receivedCollectionCued: Binding<Bool> {
    Binding (
      get: { self.environment.state.library.cuedCollection != nil },
      set: { _ = $0 }
    )
  }
  
  var body: some View {
    ZStack {
      TabView(selection: $selectedTab) {
        OnRotation()
          .tabItem {
            Image(systemName: "music.house")
            Text("On Rotation")
        }
        .tag("onrotation")
        .environmentObject(self.environment)
        CollectionLibrary()
          .tabItem {
            Image(systemName: "rectangle.on.rectangle.angled")
            Text("Collection Library")
        }
        .tag("library")
        .environmentObject(self.environment)
      }
      .disabled(environment.state.options.firstTimeRun)
      .alert(isPresented: receivedCollectionCued) {
        Alert(title: Text("Shared collection received."),
              message: Text("Would you like to add \"\(environment.state.library.cuedCollection!.collectionName)\" by \"\(environment.state.library.cuedCollection!.collectionCurator)\" to your Shared Library?"),
              primaryButton: .cancel(Text("Cancel")) {
                self.environment.update(action: LibraryAction.uncueSharedCollection)
          },
              secondaryButton: .default(Text("Add").bold()) {
                self.selectedTab = "library"
                SharedCollectionManager.expandShareableCollection(shareableCollection: self.environment.state.library.cuedCollection!)
                self.environment.update(action: LibraryAction.uncueSharedCollection)
          })
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
