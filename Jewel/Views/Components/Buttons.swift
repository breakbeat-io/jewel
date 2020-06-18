//
//  UserCollectionButtons.swift
//  Listen Later
//
//  Created by Greg Hepworth on 08/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionOptionsButton: View {
  
  @EnvironmentObject var environment: AppEnvironment
  
  let collectionId: UUID
  @Binding var editMode: Bool
  
  @State private var showOptions: Bool = false
  
  var body: some View {
    Button(action: {
      self.showOptions = true
    }) {
      Image(systemName: "ellipsis")
    }
    .sheet(isPresented: self.$showOptions) {
      CollectionOptions(collectionId: self.collectionId, showing: self.$showOptions, editMode: self.$editMode)
        .environmentObject(self.environment)
    }
  }
}

struct LibraryOptionsButton: View {
  
  @EnvironmentObject var environment: AppEnvironment
  
  @Binding var editMode: Bool
  @State private var showOptions: Bool = false
  
  var body: some View {
    Button(action: {
      self.showOptions = true
    }) {
      Image(systemName: "ellipsis")
    }
    .sheet(isPresented: self.$showOptions) {
      LibraryOptions(showing: self.$showOptions, editMode: self.$editMode)
        .environmentObject(self.environment)
    }
  }
}


struct ShareCollectionButton: View {
  
  @EnvironmentObject var environment: AppEnvironment
  
  var collectionId: UUID?
  
  @State private var showSharing: Bool = false
  @State private var showShareLink: Bool = false
  
  var body: some View {
    IfLet(collectionId) { collectionId in
      Button(action: {
        self.showSharing = true
      }) {
        HStack {
          Image(systemName: "square.and.arrow.up")
            .frame(width: 30)
          Text("Share Collection")
        }
      }
      .actionSheet(isPresented: self.$showSharing) {
        ActionSheet(
          title: Text("Share this collection as \n \"\(self.environment.state.library.onRotation.name)\" by \"\(self.environment.state.library.onRotation.curator)\""),
          buttons: [
            .default(Text("Send Share Link")) {
              self.showShareLink = true
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
      HStack {
        Image(systemName: "square.and.arrow.down")
          .frame(width: 30)
        Text("Load Recommendations")
      }
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
