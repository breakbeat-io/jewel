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
    set: { self.app.state.navigation.showCollectionOptions ? self.app.update(action: NavigationAction.showCollectionOptions($0)) : () }
  )}
  
  var body: some View {
    HStack {
      Spacer()
      if app.state.navigation.collectionIsEditing {
        Button(action: {
          self.app.update(action: LibraryAction.removeSourcesFromCollection(slotIndexes: self.app.state.navigation.collectionEditSelection, collectionId: self.app.state.navigation.activeCollectionId!))
          self.app.update(action: NavigationAction.editCollection(false))
          self.app.update(action: NavigationAction.clearCollectionEditSelection)
        }) {
          Image(systemName: "trash")
        }
        .padding(.trailing)
        Button(action: {
          self.app.update(action: NavigationAction.editCollection(false))
        }) {
          Image(systemName: "checkmark")
        }
      } else {
        Spacer()
        Button(action: {
          self.app.update(action: NavigationAction.showCollectionOptions(true))
        }) {
          Image(systemName: "ellipsis")
        }
        .padding(.leading)
        .sheet(isPresented: showCollectionOptions) {
          CollectionOptions()
            .environmentObject(self.app)
        }
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
    set: { self.app.state.navigation.showLibraryOptions ? self.app.update(action: NavigationAction.showLibraryOptions($0)) : () }
  )}
  
  var body: some View {
    HStack {
      Spacer()
      if app.state.navigation.libraryIsEditing {
        Button(action: {
          self.app.update(action: LibraryAction.removeCollections(collectionIds: self.app.state.navigation.libraryEditSelection))
          self.app.update(action: NavigationAction.editLibrary(false))
          self.app.update(action: NavigationAction.clearLibraryEditSelection)
        }) {
          Image(systemName: "trash")
        }
        .padding(.trailing)
        Button(action: {
          self.app.update(action: NavigationAction.editLibrary(false))
        }) {
          Image(systemName: "checkmark")
        }
      } else {
        Button(action: {
          self.app.update(action: LibraryAction.createCollection)
          self.app.update(action: NavigationAction.setActiveCollectionId(collectionId: self.app.state.library.collections.first!.id))
          self.app.update(action: NavigationAction.showCollection(true))
        }) {
          Image(systemName: "plus")
        }
        .padding(.leading)
        Button(action: {
          self.app.update(action: NavigationAction.showLibraryOptions(true))
        }) {
          Image(systemName: "ellipsis")
        }
        .padding(.leading)
        .sheet(isPresented: showLibraryOptions) {
          LibraryOptions()
            .environmentObject(self.app)
        }
      }
    }
    .padding(.vertical)
    .frame(width: Constants.buttonWidth)
  }
}
