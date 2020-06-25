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
  
  var collection: Collection
  
  @State private var showSharing: Bool = false
  
  private var isOnRotation: Bool {
    self.collection.id == self.app.state.library.onRotation.id
  }
  
  var body: some View {
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
      ShareSheetLoader(collection: self.collection)
        .environmentObject(self.app)
    }
  }
}
