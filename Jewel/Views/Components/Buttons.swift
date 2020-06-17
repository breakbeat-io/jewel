//
//  UserCollectionButtons.swift
//  Listen Later
//
//  Created by Greg Hepworth on 08/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct OptionsButton: View {
  
  @EnvironmentObject var environment: AppEnvironment
  
  @State private var showOptions: Bool = false
  
  var body: some View {
    Button(action: {
      self.showOptions = true
    }) {
      Image(systemName: "ellipsis")
    }
    .sheet(isPresented: self.$showOptions) {
      OptionsHome(showing: self.$showOptions)
        .environmentObject(self.environment)
    }
  }
}

struct SharingOptionsButton: View {
  
  @EnvironmentObject var environment: AppEnvironment
  
  var collectionId: UUID?
  
  @State private var showSharing: Bool = false
  @State private var showShareLink: Bool = false
  
  private var collectionEmpty: Bool {
    environment.state.library.onRotation.slots.filter( { $0.album != nil }).count == 0
  }
  
  var body: some View {
    IfLet(collectionId) { collectionId in
      Button(action: {
        self.showSharing = true
      }) {
        HStack {
          Image(systemName: "square.and.arrow.up")
          Text("Share Collection")
        }
      }
      .disabled(self.collectionEmpty)
      .actionSheet(isPresented: self.$showSharing) {
        ActionSheet(
          title: Text("Share this collection as \n \"\(self.environment.state.library.onRotation.name)\" by \"\(self.environment.state.library.onRotation.curator)\""),
          buttons: [
            .default(Text("Send Share Link")) {
              self.showShareLink = true
            },
            .default(Text("Add to my Collection Library")) {
              self.environment.update(action: LibraryAction.saveOnRotation(collection: self.environment.state.library.onRotation))
            },
            .cancel()
          ]
        )
      }
      .sheet(isPresented: self.$showShareLink) {
        ShareSheetLoader(collectionId: collectionId)
          .environmentObject(self.environment)
      }
    }
  }
}

struct RecommendationsButton: View {
  
  @State private var showLoadRecommendationsAlert = false
  
  var body: some View {
    Button(action: {
      self.showLoadRecommendationsAlert = true
    }) {
      Image(systemName: "square.and.arrow.down")
    }
    .alert(isPresented: $showLoadRecommendationsAlert) {
      Alert(title: Text("Add our current Recommended Collection?"),
            message: Text("Every three months we publish a Collection of new and classic albums for you to listen to."),
            primaryButton: .cancel(Text("Cancel")),
            secondaryButton: .default(Text("Add").bold()) {
              SharedCollectionManager.loadRecommendations()
        })
    }
  }
}

struct AddCollectionButton: View {
  
  @EnvironmentObject var environment: AppEnvironment
  
  var body: some View {
    Button(action: {
      self.environment.update(action: LibraryAction.addUserCollection)
    }) {
      Image(systemName: "plus")
    }
  }
}
