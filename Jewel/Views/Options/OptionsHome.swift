//
//  Options.swift
//  Jewel
//
//  Created by Greg Hepworth on 31/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct OptionsHome: View {
  
  @EnvironmentObject private var store: AppStore
  
  @Binding var showing: Bool
  
  @State var collectionName: String = ""
  @State var collectionCurator: String = ""
  
  private var preferredMusicPlatform: Binding<Int> { Binding (
    get: { self.store.state.options.preferredMusicPlatform },
    set: { self.store.update(action: OptionsAction.setPreferredPlatform(platform: $0)) }
    )
  }
  
  
  var body: some View {
    NavigationView {
      VStack {
        Form {
          Section(footer: Text("Choose a name for your collection, and to represent the curator when sharing the collection.")) {
            HStack(alignment: .firstTextBaseline) {
              Text("Collection Name")
              TextField(
                store.state.collection.name,
                text: $collectionName,
                onCommit: {
                  self.store.update(action: CollectionAction.changeCollectionName(name: self.collectionName))
                  self.showing = false
              }
              ).foregroundColor(.accentColor)
            }
            HStack(alignment: .firstTextBaseline) {
              Text("Curator")
              TextField(
                store.state.collection.curator,
                text: $collectionCurator,
                onCommit: {
                  self.store.update(action: CollectionAction.changeCollectionCurator(curator: self.collectionCurator))
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
          if store.state.options.debugMode {
            Section(header: Text("Debug")) {
              Button(action: {
                self.store.update(action: OptionsAction.reset)
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
            self.store.update(action: OptionsAction.toggleDebugMode)
        }
        .padding()
      }
      .navigationBarTitle("Options", displayMode: .inline)
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
