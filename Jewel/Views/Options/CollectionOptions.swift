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
  
  private var collection: Collection? {
    if app.state.navigation.onRotationActive {
      return self.app.state.library.onRotation
    } else {
      return self.app.state.library.collections.first(where: { $0.id == self.app.state.navigation.activeCollectionId })
    }
  }
  private var collectionEmpty: Bool {
    collection?.slots.filter( { $0.album != nil }).count == 0
  }
  
  @State private var newCollectionName: String = ""
  private var collectionName: Binding<String> { Binding (
    get: { (self.collection?.name ?? "") },
    set: { self.newCollectionName = $0 }
  )}
  
  @State private var newCollectionCurator: String = ""
  private var collectionCurator: Binding<String> { Binding (
    get: { self.collection?.curator ?? ""},
    set: { self.newCollectionCurator = $0 }
  )}
  
  var body: some View {
    IfLet(self.collection) { collection in // this IfLet has to be outside the NavigationView else LibraryAction.removeCollection creates an exception ¯\_(ツ)_/¯
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
                  Text(Image(systemName: "arrow.right.square"))
                    .font(.body)
                    .frame(width: Constants.optionsButtonIconWidth)
                  Text("Add to my Collection Library")
                    .font(.body)
                }
              }
            } else {
              Button {
                self.app.update(action: LibraryAction.duplicateCollection(collection: collection))
                self.app.update(action: NavigationAction.showCollectionOptions(false))
                self.app.update(action: NavigationAction.showCollection(false))
              } label: {
                HStack {
                  Text(Image(systemName: "doc.on.doc"))
                    .font(.body)
                    .frame(width: Constants.optionsButtonIconWidth)
                  Text("Duplicate Collection")
                    .font(.body)
                }
              }
              Button {
                self.app.update(action: LibraryAction.removeCollection(collectionId: collection.id))
                self.app.update(action: NavigationAction.showCollectionOptions(false))
                self.app.update(action: NavigationAction.showCollection(false))
              } label: {
                HStack {
                  Text(Image(systemName: "delete.left"))
                    .font(.body)
                    .frame(width: Constants.optionsButtonIconWidth)
                  Text("Delete Collection")
                    .font(.body)
                }
                .foregroundColor(self.collectionEmpty ? nil : .red)
              }
            }
          }
          .disabled(self.collectionEmpty)
          if !app.state.navigation.onRotationActive {
            Section {
              HStack {
                Text("Collection Name")
                  .font(.body)
                TextField(
                  collectionName.wrappedValue,
                  text: collectionName,
                  onEditingChanged: { _ in
                    if !self.newCollectionName.isEmpty && self.newCollectionName != collection.name {
                      self.app.update(action: LibraryAction.setCollectionName(name: self.newCollectionName.trimmingCharacters(in: .whitespaces), collectionId: collection.id))
                    }
                  }
                )
                .font(.body)
                .foregroundColor(.accentColor)
              }
              HStack {
                Text("Curator")
                  .font(.body)
                TextField(
                  collectionCurator.wrappedValue,
                  text: collectionCurator,
                  onEditingChanged: { _ in
                    if !self.newCollectionCurator.isEmpty && self.newCollectionCurator != collection.curator {
                      self.app.update(action: LibraryAction.setCollectionCurator(curator: self.newCollectionCurator.trimmingCharacters(in: .whitespaces), collectionId: collection.id))
                    }
                  }
                )
                .font(.body)
                .foregroundColor(.accentColor)
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
                .font(.body)
            }
        )
      }
      .navigationViewStyle(StackNavigationViewStyle())
    }
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
        Text(Image(systemName: "square.and.arrow.up"))
          .font(.body)
          .frame(width: Constants.optionsButtonIconWidth)
        Text("Share \(self.app.state.navigation.onRotationActive ? Navigation.Tab.onRotation.rawValue : "Collection")")
          .font(.body)
      }
    }
    .sheet(isPresented: showSharing) {
      ShareSheetLoader(collection: self.collection)
        .environmentObject(self.app)
    }
  }
}

