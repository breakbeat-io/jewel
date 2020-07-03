//
//  Options.swift
//  Jewel
//
//  Created by Greg Hepworth on 31/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionOptions: View {
  
  @EnvironmentObject private var app: AppEnvironment

  private var collection: Collection {
    if app.state.navigation.onRotationActive {
      return self.app.state.library.onRotation
    } else {
      return self.app.state.library.collections.first(where: { $0.id == self.app.state.navigation.activeCollectionId })!
    }
  }
  private var collectionEmpty: Bool {
    collection.slots.filter( { $0.source != nil }).count == 0
  }
  private var collectionName: Binding<String> { Binding (
    get: { self.collection.name },
    set: { self.app.update(action: LibraryAction.setCollectionName(name: $0, collectionId: self.app.state.navigation.activeCollectionId!))}
    )}
  private var collectionCurator: Binding<String> { Binding (
    get: { self.collection.curator },
    set: { self.app.update(action: LibraryAction.setCollectionCurator(curator: $0, collectionId: self.app.state.navigation.activeCollectionId!))}
    )}
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          
          ShareCollectionButton(collection: collection)
          
          if app.state.navigation.onRotationActive {
            Button(action: {
              self.app.update(action: NavigationAction.switchTab(to: .library))
              self.app.update(action: NavigationAction.showCollectionOptions(false))
              self.app.update(action: LibraryAction.saveOnRotation(collection: self.app.state.library.onRotation))
            }) {
              HStack {
                Image(systemName: "arrow.right.square")
                  .frame(width: Constants.optionsButtonIconWidth)
                Text("Add to my Collection Library")
              }
            }
          }
          if collection.type == .userCollection {
            Button(action: {
              self.app.update(action: NavigationAction.editCollection(true))
              self.app.update(action: NavigationAction.showCollectionOptions(false))
            }) {
              HStack {
                Image(systemName: "square.stack.3d.up")
                  .frame(width: Constants.optionsButtonIconWidth)
                Text("Reorder \(app.state.navigation.onRotationActive ? Navigation.Tab.onRotation.rawValue : "Collection")")
              }
            }
          }
        }
        .disabled(self.collectionEmpty)
        
        if !app.state.navigation.onRotationActive {
          Section {
            HStack {
              Text("Collection Name")
              TextField(
                collectionName.wrappedValue,
                text: collectionName,
                onCommit: {
                  self.app.update(action: NavigationAction.showCollectionOptions(false))
              }
              ).foregroundColor(.accentColor)
            }
            HStack {
              Text("Curator")
              TextField(
                collectionCurator.wrappedValue,
                text: collectionCurator,
                onCommit: {
                  self.app.update(action: NavigationAction.showCollectionOptions(false))
              }
              ).foregroundColor(.accentColor)
            }
          }
          .disabled(collection.type != .userCollection)
        }
      }
      
      .navigationBarTitle("\(app.state.navigation.onRotationActive ? Navigation.Tab.onRotation.rawValue : "Collection") Options", displayMode: .inline)
      .navigationBarItems(
        leading:
        Button(action: {
          self.app.update(action: NavigationAction.showCollectionOptions(false))
        }) {
          Text("Close")
        }
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct ShareCollectionButton: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var showSharing: Binding<Bool> { Binding (
    get: { self.app.state.navigation.showSharing },
    set: { self.app.state.navigation.showSharing ? self.app.update(action: NavigationAction.showSharing($0)) : () }
    )}
  
  var collection: Collection

  var body: some View {
    Button(action: {
      self.app.update(action: NavigationAction.showSharing(true))
    }) {
      HStack {
        Image(systemName: "square.and.arrow.up")
          .frame(width: Constants.optionsButtonIconWidth)
        Text("Share \(self.app.state.navigation.onRotationActive ? Navigation.Tab.onRotation.rawValue : "Collection")")
      }
    }
    .sheet(isPresented: showSharing) {
      ShareSheetLoader(collection: self.collection)
        .environmentObject(self.app)
    }
  }
}

