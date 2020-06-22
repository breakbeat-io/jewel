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
      self.app.navigation.showSettings = true
    }) {
      Image(systemName: "gear")
    }
    .sheet(isPresented: $app.navigation.showSettings) {
        Settings()
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
              self.app.navigation.showOptions = false
              SharedCollectionManager.loadRecommendations()
        })
    }
  }
}

