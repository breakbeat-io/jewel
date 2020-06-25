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
        Spacer()
          .padding(.vertical)
          .frame(width: Constants.buttonWidth)
        Picker("Library", selection: $app.navigation.selectedTab) {
          Image(systemName: "music.house")
            .tag(Navigation.Tab.onrotation)
          Image(systemName: "rectangle.on.rectangle.angled")
            .tag(Navigation.Tab.library)
        }
        .pickerStyle(SegmentedPickerStyle())
        HomeActionButtons()
      }
      .padding(.horizontal)
      Rectangle()
        .frame(height: 1.0, alignment: .bottom)
        .foregroundColor(Color(UIColor.systemFill))
    }
  }
}

struct HomeActionButtons: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var collectionId: UUID {
    self.app.state.library.onRotation.id
  }
  
  var body: some View {
    HStack {
      Spacer()
      if app.navigation.listIsEditing {
        Button(action: {
          if self.app.navigation.selectedTab == .onrotation {
            self.app.update(action: LibraryAction.removeSourcesFromCollection(sourceIds: self.app.navigation.collectionEditSelection, collectionId: self.collectionId))
            self.app.navigation.listIsEditing = false
            self.app.navigation.collectionEditSelection.removeAll()
          }
          
          if self.app.navigation.selectedTab == .library {
            self.app.update(action: LibraryAction.removeSharedCollections(collectionIds: self.app.navigation.libraryEditSelection))
            self.app.navigation.listIsEditing = false
            self.app.navigation.libraryEditSelection.removeAll()
          }
        }) {
          Image(systemName: "trash")
        }
        .padding(.trailing)
        Button(action: {
          self.app.navigation.listIsEditing.toggle()
        }) {
          Image(systemName: "checkmark")
        }
      } else {
        if self.app.navigation.selectedTab == .library {
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
        .sheet(isPresented: self.$app.navigation.showOptions) {
          if self.app.navigation.selectedTab == .onrotation {
            CollectionOptions(collectionId: self.app.state.library.onRotation.id)
              .environmentObject(self.app)
          } else {
            if self.app.navigation.selectedCollection == nil {
              LibraryOptions()
                .environmentObject(self.app)
            }
          }
        }
      }
    }
    .padding(.vertical)
    .frame(width: Constants.buttonWidth)
  }
}
