//
//  Options.swift
//  Jewel
//
//  Created by Greg Hepworth on 31/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct OptionsHome: View {
  
  @EnvironmentObject private var environment: AppEnvironment
  
  let collectionId: UUID
  
  @Binding var showing: Bool
  
  private var collection: Collection {
    if self.collectionId == self.environment.state.library.onRotation.id {
      return self.environment.state.library.onRotation
    } else {
      return self.environment.state.library.collections.first(where: { $0.id == self.collectionId })!
    }
  }

  private var collectionName: Binding<String> { Binding (
    get: { self.collection.name },
    set: { self.environment.update(action: LibraryAction.setCollectionName(name: $0, collectionId: self.collectionId))}
    )}
  private var collectionCurator: Binding<String> { Binding (
    get: { self.collection.curator },
    set: { self.environment.update(action: LibraryAction.setCollectionCurator(curator: $0, collectionId: self.collectionId))}
    )}
  private var preferredMusicPlatform: Binding<Int> { Binding (
    get: { self.environment.state.options.preferredMusicPlatform },
    set: { self.environment.update(action: OptionsAction.setPreferredPlatform(platform: $0)) }
    )
  }
  
  var body: some View {
    NavigationView {
      VStack {
        Form {
          SharingOptionsButton(collectionId: collectionId)
          RecommendationsButton()
          Section(footer: Text("Choose a name for your collection, and to represent the curator when sharing the collection.")) {
            HStack {
              Text("Collection Name")
              TextField(
                environment.state.library.onRotation.name,
                text: collectionName,
                onCommit: {
                  self.showing = false
              }
              ).foregroundColor(.accentColor)
            }
            HStack {
              Text("Curator")
              TextField(
                environment.state.library.onRotation.curator,
                text: collectionCurator,
                onCommit: {
                  self.showing = false
              }
              ).foregroundColor(.accentColor)
            }
          }
          Section(footer: Text("Use this service for playback if available, otherwise use Apple Music.")) {
            Picker(selection: preferredMusicPlatform, label: Text("Playback Service")) {
              ForEach(0 ..< OdesliPlatform.allCases.count, id: \.self) {
                Text(OdesliPlatform.allCases[$0].friendlyName)
              }
            }
          }
          if environment.state.options.debugMode {
            Section(header: Text("Debug")) {
              Button(action: {
                self.environment.update(action: OptionsAction.reset)
              }) {
                Text("Reset Jewel")
                  .foregroundColor(.red)
              }
            }
          }
        }
        Spacer()
        Footer()
          .onTapGesture(count: 10) {
            self.environment.update(action: OptionsAction.toggleDebugMode)
        }
        .padding()
      }
      .navigationBarTitle("Collection Options", displayMode: .inline)
      .navigationBarItems(trailing:
        Button(action: {
          self.showing = false
        }) {
          Text("Close")
        }
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}
