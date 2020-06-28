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
    if app.navigation.onRotationActive {
      return self.app.state.library.onRotation
    } else {
      return self.app.state.library.collections.first(where: { $0.id == self.app.navigation.activeCollectionId })!
    }
  }
  private var collectionEmpty: Bool {
    collection.slots.filter( { $0.source != nil }).count == 0
  }
  private var collectionName: Binding<String> { Binding (
    get: { self.collection.name },
    set: { self.app.update(action: LibraryAction.setCollectionName(name: $0, collectionId: self.app.navigation.activeCollectionId))}
    )}
  private var collectionCurator: Binding<String> { Binding (
    get: { self.collection.curator },
    set: { self.app.update(action: LibraryAction.setCollectionCurator(curator: $0, collectionId: self.app.navigation.activeCollectionId))}
    )}
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          
          ShareCollectionButton(collection: collection)
          
          if app.navigation.onRotationActive {
            Button(action: {
              self.app.navigation.selectedTab = .library
              self.app.navigation.showCollectionOptions = false
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
              self.app.navigation.collectionIsEditing = true
              self.app.navigation.showCollectionOptions = false
            }) {
              HStack {
                Image(systemName: "square.stack.3d.up")
                  .frame(width: Constants.optionsButtonIconWidth)
                Text("Reorder \(app.navigation.onRotationActive ? Navigation.Tab.onRotation.rawValue : "Collection")")
              }
            }
          }
        }
        .disabled(self.collectionEmpty)
        
        if !app.navigation.onRotationActive {
          Section {
            HStack {
              Text("Collection Name")
              TextField(
                collectionName.wrappedValue,
                text: collectionName,
                onCommit: {
                  self.app.navigation.showCollectionOptions = false
              }
              ).foregroundColor(.accentColor)
            }
            HStack {
              Text("Curator")
              TextField(
                collectionCurator.wrappedValue,
                text: collectionCurator,
                onCommit: {
                  self.app.navigation.showCollectionOptions = false
              }
              ).foregroundColor(.accentColor)
            }
          }
          .disabled(collection.type != .userCollection)
        }
      }
      
      .navigationBarTitle("\(app.navigation.onRotationActive ? Navigation.Tab.onRotation.rawValue : "Collection") Options", displayMode: .inline)
      .navigationBarItems(
        leading:
        Button(action: {
          self.app.navigation.showCollectionOptions = false
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
  
  var collection: Collection
  
  @State private var showSharing: Bool = false

  var body: some View {
    Button(action: {
      self.showSharing = true
    }) {
      HStack {
        Image(systemName: "square.and.arrow.up")
          .frame(width: Constants.optionsButtonIconWidth)
        Text("Share \(self.app.navigation.onRotationActive ? Navigation.Tab.onRotation.rawValue : "Collection")")
      }
    }
    .sheet(isPresented: self.$showSharing) {
      ShareSheetLoader(collection: self.collection)
        .environmentObject(self.app)
    }
  }
}

