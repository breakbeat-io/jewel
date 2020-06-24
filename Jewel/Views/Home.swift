//
//  NewHome.swift
//  Listen Later
//
//  Created by Greg Hepworth on 21/06/2020.
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
      Color(UIColor.systemBackground)
        .edgesIgnoringSafeArea(.bottom)
      Color(UIColor.secondarySystemBackground)
        .edgesIgnoringSafeArea(.top)
      VStack(spacing: 0) {
        NavBar()
        VStack {
          if app.navigation.selectedTab == .onrotation {
            OnRotation()
              .transition(.move(edge: .leading))
              .animation(.easeInOut)
          }
          if app.navigation.selectedTab == .library {
              CollectionLibrary()
                .transition(.move(edge: .trailing))
                .animation(.easeInOut)
          }
        }
        .background(Color(UIColor.systemBackground))
      }
      .disabled(app.state.options.firstTimeRun)
      .blur(radius: app.state.options.firstTimeRun ? 10 : 0)
      if app.state.options.firstTimeRun {
        Welcome()
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
