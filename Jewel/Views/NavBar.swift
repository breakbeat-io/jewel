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
  
  var body: some View {
    VStack {
      HStack {
        SettingsButton()
        Spacer()
        Picker("Library", selection: $app.state.navigation.selectedTab) {
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
  
  var body: some View {
    HStack {
      Spacer()
      if app.state.navigation.collectionIsEditing {
        Button(action: {
          self.app.update(action: LibraryAction.removeSourcesFromCollection(sourceIds: self.app.state.navigation.collectionEditSelection, collectionId: self.app.state.navigation.activeCollectionId!))
          self.app.update(action: NavigationAction.editCollection(false))
          self.app.state.navigation.collectionEditSelection.removeAll()
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
        .sheet(isPresented: self.$app.state.navigation.showCollectionOptions) {
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
  
  var body: some View {
    HStack {
      Spacer()
      if app.state.navigation.libraryIsEditing {
        Button(action: {
          self.app.update(action: LibraryAction.removeSharedCollections(collectionIds: self.app.state.navigation.libraryEditSelection))
          self.app.update(action: NavigationAction.editLibrary(false))
          self.app.state.navigation.libraryEditSelection.removeAll()
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
          self.app.update(action: LibraryAction.addUserCollection)
          self.app.state.navigation.activeCollectionId = self.app.state.library.collections.first!.id
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
        .sheet(isPresented: self.$app.state.navigation.showLibraryOptions) {
          LibraryOptions()
            .environmentObject(self.app)
        }
      }
    }
    .padding(.vertical)
    .frame(width: Constants.buttonWidth)
  }
}
