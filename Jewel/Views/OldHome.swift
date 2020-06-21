//
//  Home.swift
//  Listen Later
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct OldHome: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var receivedCollectionCued: Binding<Bool> {
    Binding (
      get: { self.app.state.library.cuedCollection != nil },
      set: { _ = $0 }
    )
  }
  
  var body: some View {
    ZStack {
      NavigationView {
        TabView(selection: $app.navigation.selectedTab) {
          
          OldOnRotation()
            .tabItem {
              Image(systemName: "music.house")
              Text("On Rotation")
          }
          .tag(Navigation.Tab.onrotation)
          
          OldCollectionLibrary()
            .tabItem {
              Image(systemName: "rectangle.on.rectangle.angled")
              Text("Collection Library")
          }
          .tag(Navigation.Tab.library)
          
        }
        .environmentObject(app)
        .navigationBarTitle(app.navigation.selectedTab.rawValue)
        .navigationBarItems(
          leading: EditButtons(),
          trailing: OptionsButtons()
        )
      }
      .disabled(app.state.options.firstTimeRun)
      .blur(radius: app.state.options.firstTimeRun ? 10 : 0)
      if app.state.options.firstTimeRun {
        Welcome()
      }
    }
    .sheet(isPresented: self.$app.navigation.showOptions) {
      if self.app.navigation.selectedTab == .onrotation {
        CollectionOptions(collectionId: self.app.state.library.onRotation.id)
          .environmentObject(self.app)
      } else {
        LibraryOptions()
          .environmentObject(self.app)
      }
    }
    .alert(isPresented: receivedCollectionCued) {
      Alert(title: Text("Shared collection received."),
            message: Text("Would you like to add \"\(app.state.library.cuedCollection!.collectionName)\" by \"\(app.state.library.cuedCollection!.collectionCurator)\" to your Shared Library?"),
            primaryButton: .cancel(Text("Cancel")) {
              self.app.update(action: LibraryAction.uncueSharedCollection)
        },
            secondaryButton: .default(Text("Add").bold()) {
              self.app.navigation.selectedTab = .library
              SharedCollectionManager.expandShareableCollection(shareableCollection: self.app.state.library.cuedCollection!)
              self.app.update(action: LibraryAction.uncueSharedCollection)
        }
      )
    }
    .onAppear {
      UITableView.appearance().separatorStyle = .none
    }
  }
}
