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
  
  let collectionId: UUID
  
  private var collection: Collection {
    if self.collectionId == self.app.state.library.onRotation.id {
      return self.app.state.library.onRotation
    } else {
      return self.app.state.library.collections.first(where: { $0.id == self.collectionId })!
    }
  }
  private var collectionEmpty: Bool {
    collection.slots.filter( { $0.album != nil }).count == 0
  }
  private var collectionName: Binding<String> { Binding (
    get: { self.collection.name },
    set: { self.app.update(action: LibraryAction.setCollectionName(name: $0, collectionId: self.collectionId))}
    )}
  private var collectionCurator: Binding<String> { Binding (
    get: { self.collection.curator },
    set: { self.app.update(action: LibraryAction.setCollectionCurator(curator: $0, collectionId: self.collectionId))}
    )}
  private var preferredMusicPlatform: Binding<Int> { Binding (
    get: { self.app.state.options.preferredMusicPlatform },
    set: { self.app.update(action: OptionsAction.setPreferredPlatform(platform: $0)) }
    )
  }
  
  var body: some View {
    NavigationView {
      VStack {
        Form {
          
          Section {
            ShareCollectionButton(collectionId: collectionId)
            if collection.id == app.state.library.onRotation.id {
              Button(action: {
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
                  Text("Reorder Collection")
                }
              }
            }
          }
          .disabled(self.collectionEmpty)
          
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
          
          Section(header: Text("APP OPTIONS"), footer: Text("Use this service for playback if available, otherwise use Apple Music.")) {
            Picker(selection: preferredMusicPlatform, label: Text("Playback Service")) {
              ForEach(0 ..< OdesliPlatform.allCases.count, id: \.self) {
                Text(OdesliPlatform.allCases[$0].friendlyName)
              }
            }
          }
          if app.state.options.debugMode {
            Button(action: {
              self.app.update(action: OptionsAction.reset)
            }) {
              Text("Reset Jewel")
                .foregroundColor(.red)
            }
          }
        }
        Spacer()
        Footer()
          .onTapGesture(count: 10) {
            self.app.update(action: OptionsAction.toggleDebugMode)
        }
        .padding()
      }
      .navigationBarTitle("Collection Options", displayMode: .inline)
      .navigationBarItems(trailing:
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

