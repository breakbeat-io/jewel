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
  
  @State private var newCollectionName: String = ""
  private var collectionName: Binding<String> { Binding (
    get: { self.collection.name },
    set: { self.newCollectionName = $0 }
    )}
  
  @State private var newCollectionCurator: String = ""
  private var collectionCurator: Binding<String> { Binding (
    get: { self.collection.curator },
    set: { self.newCollectionCurator = $0 }
    )}
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          
          #if !targetEnvironment(macCatalyst)
          ShareCollectionButton(collection: collection)
          #endif
          
          if app.state.navigation.onRotationActive {
            Button {
              self.app.update(action: NavigationAction.switchTab(to: .library))
              self.app.update(action: NavigationAction.showCollectionOptions(false))
              self.app.update(action: LibraryAction.saveOnRotation(collection: self.app.state.library.onRotation))
            } label: {
              HStack {
                Image(systemName: "arrow.right.square")
                  .frame(width: Constants.optionsButtonIconWidth)
                Text("Add to my Collection Library")
              }
            }
          } else {
            Button {
              self.app.update(action: LibraryAction.duplicateCollection(collection: self.collection))
              self.app.update(action: NavigationAction.showCollectionOptions(false))
              self.app.update(action: NavigationAction.showCollection(false))
            } label: {
              HStack {
                Image(systemName: "doc.on.doc")
                  .frame(width: Constants.optionsButtonIconWidth)
                Text("Duplicate Collection")
              }
            }
          }
          if collection.type == .userCollection {
            Button {
              self.app.update(action: NavigationAction.editCollection(true))
              self.app.update(action: NavigationAction.showCollectionOptions(false))
            } label: {
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
                onEditingChanged: { _ in
                  if !self.newCollectionName.isEmpty && self.newCollectionName != self.collection.name {
                    self.app.update(action: LibraryAction.setCollectionName(name: self.newCollectionName.trimmingCharacters(in: .whitespaces), collectionId: self.collection.id))
                  }
              }
              ).foregroundColor(.accentColor)
            }
            HStack {
              Text("Curator")
              TextField(
                collectionCurator.wrappedValue,
                text: collectionCurator,
                onEditingChanged: { _ in
                  if !self.newCollectionCurator.isEmpty && self.newCollectionCurator != self.collection.curator {
                    self.app.update(action: LibraryAction.setCollectionCurator(curator: self.newCollectionCurator.trimmingCharacters(in: .whitespaces), collectionId: self.collection.id))
                  }
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
        Button {
          self.app.update(action: NavigationAction.showCollectionOptions(false))
        } label: {
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
    set: { if self.app.state.navigation.showSharing { self.app.update(action: NavigationAction.showSharing($0)) } }
    )}
  
  var collection: Collection
  
  var body: some View {
    Button {
      self.app.update(action: NavigationAction.showSharing(true))
    } label: {
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

