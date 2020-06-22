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
        EditButtons()
        Picker("Library", selection: $app.navigation.selectedTab) {
          Image(systemName: "music.house")
            .tag(Navigation.Tab.onrotation)
          Image(systemName: "rectangle.on.rectangle.angled")
            .tag(Navigation.Tab.library)
        }
        .pickerStyle(SegmentedPickerStyle())
        OptionsButtons()
      }
      .padding(.horizontal)
      Rectangle()
        .frame(height: 1.0, alignment: .bottom)
        .foregroundColor(Color(UIColor.systemFill))
    }
  }
}

struct EditButtons: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var collectionId: UUID {
    app.state.library.onRotation.id
  }
  
  var body: some View {
    HStack {
      if app.navigation.selectedTab == .onrotation && self.app.navigation.collectionIsEditing {
        Button(action: {
          self.app.update(action: LibraryAction.removeAlbumsFromCollection(albumIds: self.app.navigation.collectionEditSelection, collectionId: self.collectionId))
          self.app.navigation.collectionIsEditing.toggle()
          self.app.navigation.collectionEditSelection = Set<Int>()
        }) {
          Image(systemName: "trash")
        }
        .padding(.trailing)
        Button(action: {
          self.app.navigation.collectionIsEditing.toggle()
        }) {
          Text("Done")
        }
      }
      
      if app.navigation.selectedTab == .library && self.app.navigation.libraryIsEditing {
        Button(action: {
          self.app.update(action: LibraryAction.removeSharedCollections(collectionIds: self.app.navigation.libraryEditSelection))
          self.app.navigation.libraryIsEditing.toggle()
          self.app.navigation.libraryEditSelection = Set<UUID>()
        }) {
          Image(systemName: "trash")
        }
        .padding(.trailing)
        Button(action: {
          self.app.navigation.libraryIsEditing.toggle()
        }) {
          Text("Done")
        }
      }
    }
    .padding(.vertical)
    .frame(width: ViewConstants.buttonWidth)
  }
}

struct OptionsButtons: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    HStack {
      if app.navigation.selectedTab == .library {
        Button(action: {
          self.app.update(action: LibraryAction.addUserCollection)
        }) {
          Image(systemName: "plus")
        }
        .padding(.leading)
      } else {
        Spacer()
      }
      Button(action: {
        self.app.navigation.showOptions = true
      }) {
        Image(systemName: "ellipsis")
      }
      .padding(.leading)
    }
    .padding(.vertical)
    .frame(width: ViewConstants.buttonWidth)
  }
}
