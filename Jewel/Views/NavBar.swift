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
        BackButton().hidden()
        Picker("Library", selection: $app.navigation.selectedTab) {
          Image(systemName: "music.house")
            .tag(Navigation.Tab.onrotation)
          Image(systemName: "rectangle.on.rectangle.angled")
            .tag(Navigation.Tab.library)
        }
        .pickerStyle(SegmentedPickerStyle())
        ActionButtons()
      }
      .padding(.horizontal)
      Rectangle()
        .frame(height: 1.0, alignment: .bottom)
        .foregroundColor(Color(UIColor.systemFill))
    }
  }
}

struct BackButton: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    HStack {
      Button(action: {

      }) {
        Image(systemName: "chevron.left")
      }
      Spacer()
    }
    .padding(.vertical)
    .frame(width: Constants.buttonWidth)
  }
}

struct ActionButtons: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var collectionId: UUID {
    app.state.library.onRotation.id
  }
  
  private var isEditing: Bool {
    self.app.navigation.collectionIsEditing || self.app.navigation.libraryIsEditing
  }
  
  var body: some View {
    HStack {
      if isEditing {
        Spacer()
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
            Image(systemName: "checkmark")
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
            Image(systemName: "checkmark")
          }
        }
      } else {
          if app.navigation.selectedTab == .library {
            Spacer()
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
              LibraryOptions()
                .environmentObject(self.app)
            }
          }
      }
      
    }
    .padding(.vertical)
    .frame(width: Constants.buttonWidth)
  }
}
