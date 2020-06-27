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
        Picker("Library", selection: $app.navigation.selectedTab) {
          Image(systemName: "music.house")
            .tag(Navigation.Tab.onRotation)
          Image(systemName: "rectangle.on.rectangle.angled")
            .tag(Navigation.Tab.library)
        }
        .pickerStyle(SegmentedPickerStyle())
        .frame(maxWidth: 300)
        Spacer()
        if app.navigation.selectedTab == .onRotation {
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
      if app.navigation.collectionIsEditing {
        Button(action: {
          self.app.update(action: LibraryAction.removeSourcesFromCollection(sourceIds: self.app.navigation.collectionEditSelection, collectionId: self.app.navigation.activeCollectionId))
          self.app.navigation.collectionIsEditing = false
          self.app.navigation.collectionEditSelection.removeAll()
        }) {
          Image(systemName: "trash")
        }
        .padding(.trailing)
        Button(action: {
          self.app.navigation.collectionIsEditing.toggle()
        }) {
          Image(systemName: "checkmark")
        }
      } else {
        Spacer()
        Button(action: {
          self.app.navigation.showCollectionOptions = true
        }) {
          Image(systemName: "ellipsis")
        }
        .padding(.leading)
        .sheet(isPresented: self.$app.navigation.showCollectionOptions) {
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
      if app.navigation.libraryIsEditing {
        Button(action: {
          self.app.update(action: LibraryAction.removeSharedCollections(collectionIds: self.app.navigation.libraryEditSelection))
          self.app.navigation.libraryIsEditing = false
          self.app.navigation.libraryEditSelection.removeAll()
        }) {
          Image(systemName: "trash")
        }
        .padding(.trailing)
        Button(action: {
          self.app.navigation.libraryIsEditing.toggle()
        }) {
          Image(systemName: "checkmark")
        }
      } else {
        Button(action: {
          self.app.update(action: LibraryAction.addUserCollection)
          self.app.navigation.activeCollectionId = self.app.state.library.collections.first!.id
          self.app.navigation.showCollection = true
        }) {
          Image(systemName: "plus")
        }
        .padding(.leading)
        Button(action: {
          self.app.navigation.showLibraryOptions = true
        }) {
          Image(systemName: "ellipsis")
        }
        .padding(.leading)
        .sheet(isPresented: self.$app.navigation.showLibraryOptions) {
          LibraryOptions()
            .environmentObject(self.app)
        }
      }
    }
    .padding(.vertical)
    .frame(width: Constants.buttonWidth)
  }
}
