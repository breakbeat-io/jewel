//
//  UserCollectionButtons.swift
//  Listen Later
//
//  Created by Greg Hepworth on 08/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct SettingsButton: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    Button(action: {
      self.app.navigation.showSettings.toggle()
    }) {
      Image(systemName: "gear")
    }
    .sheet(isPresented: $app.navigation.showSettings) {
        Settings()
          .environmentObject(self.app)
    }
  }
}

struct CollectionEditButtons: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  let collectionId: UUID
  
  var body: some View {
    HStack {
      if self.app.navigation.collectionIsEditing {
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
    }
  }
}

struct CollectionOptionsButton: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  let collectionId: UUID
  
  var body: some View {
    Button(action: {
      self.app.navigation.showCollectionOptions = true
    }) {
      Image(systemName: "ellipsis")
    }
    .sheet(isPresented: self.$app.navigation.showCollectionOptions) {
      CollectionOptions(collectionId: self.collectionId)
        .environmentObject(self.app)
    }
  }
}

struct LibraryEditButtons: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    HStack {
      if self.app.navigation.libraryIsEditing {
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
  }
}

struct LibraryOptionsButton: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    Button(action: {
      self.app.navigation.showLibraryOptions = true
    }) {
      Image(systemName: "ellipsis")
    }
    .sheet(isPresented: self.$app.navigation.showLibraryOptions) {
      LibraryOptions()
        .environmentObject(self.app)
    }
  }
}


struct ShareCollectionButton: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var collectionId: UUID?
  
  @State private var showSharing: Bool = false
  
  private var isOnRotation: Bool {
    self.collectionId == self.app.state.library.onRotation.id
  }
  
  var body: some View {
    IfLet(collectionId) { collectionId in
      Button(action: {
        self.showSharing = true
      }) {
        HStack {
          Image(systemName: "square.and.arrow.up")
            .frame(width: Constants.optionsButtonIconWidth)
          Text("Share \(self.isOnRotation ? "On Rotation" : "Collection")")
        }
      }
      .sheet(isPresented: self.$showSharing) {
        ShareSheetLoader(collectionId: collectionId)
          .environmentObject(self.app)
      }
    }
  }
}

struct RecommendationsButton: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  @State private var showLoadRecommendationsAlert = false
  
  var body: some View {
    Button(action: {
      self.showLoadRecommendationsAlert = true
    }) {
      HStack {
        Image(systemName: "square.and.arrow.down")
          .frame(width: Constants.optionsButtonIconWidth)
        Text("Load Recommendations")
      }
    }
    .alert(isPresented: $showLoadRecommendationsAlert) {
      Alert(title: Text("Add our current Recommended Collection?"),
            message: Text("Every three months we publish a Collection of new and classic albums for you to listen to."),
            primaryButton: .cancel(Text("Cancel")),
            secondaryButton: .default(Text("Add").bold()) {
              self.app.navigation.closeOptions()
              SharedCollectionManager.loadRecommendations()
        })
    }
  }
}

struct AddCollectionButton: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    Button(action: {
      self.app.update(action: LibraryAction.addUserCollection)
    }) {
      Image(systemName: "plus")
    }
  }
}
