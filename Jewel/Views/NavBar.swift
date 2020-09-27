//
//  NavBar.swift
//  Listen Later
//
//  Created by Greg Hepworth on 21/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct NavBar: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var selectedTab: Binding<Navigation.Tab> { Binding (
    get: { self.app.state.navigation.selectedTab },
    set: { self.app.update(action: NavigationAction.switchTab(to: $0))}
  )}
  
  var body: some View {
    VStack {
      HStack {
        SettingsButton()
        Spacer()
        Picker("Library", selection: selectedTab) {
          Image(systemName: "music.house")
            .tag(Navigation.Tab.onRotation)
          Image(systemName: "rectangle.on.rectangle.angled")
            .tag(Navigation.Tab.library)
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(maxWidth: 300)
        Spacer()
        if app.state.navigation.selectedTab == .onRotation {
          CollectionActionButtons()
        } else {
          LibraryActionButtons()
        }
      }
      .padding(.horizontal)
      Rectangle()
        .frame(height: 1.0, alignment: .bottom)
        .foregroundColor(Color(UIColor.systemFill))
    }
  }
}

struct CollectionActionButtons: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var showCollectionOptions: Binding<Bool> { Binding (
    get: { self.app.state.navigation.showCollectionOptions },
    set: { if self.app.state.navigation.showCollectionOptions { self.app.update(action: NavigationAction.showCollectionOptions($0)) } }
  )}
  
  var body: some View {
    HStack {
      Spacer()
      Button {
        self.app.update(action: NavigationAction.showCollectionOptions(true))
      } label: {
        Image(systemName: "ellipsis")
      }
      .padding(.leading)
      .sheet(isPresented: showCollectionOptions) {
        CollectionOptions()
          .environmentObject(self.app)
      }
    }
    .padding(.vertical)
    .frame(width: Constants.buttonWidth)
  }
}

struct LibraryActionButtons: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var showLibraryOptions: Binding<Bool> { Binding (
    get: { self.app.state.navigation.showLibraryOptions },
    set: { if self.app.state.navigation.showLibraryOptions { self.app.update(action: NavigationAction.showLibraryOptions($0)) } }
  )}
  
  var body: some View {
    HStack {
      Spacer()
      Button {
        self.app.update(action: LibraryAction.createCollection)
        self.app.update(action: NavigationAction.setActiveCollectionId(collectionId: self.app.state.library.collections.first!.id))
        self.app.update(action: NavigationAction.showCollection(true))
      } label: {
        Image(systemName: "plus")
      }
      .padding(.leading)
      Button {
        self.app.update(action: NavigationAction.showLibraryOptions(true))
      } label: {
        Image(systemName: "ellipsis")
      }
      .padding(.leading)
      .sheet(isPresented: showLibraryOptions) {
        LibraryOptions()
          .environmentObject(self.app)
      }
    }
    .padding(.vertical)
    .frame(width: Constants.buttonWidth)
  }
}
