//
//  LibraryOptions.swift
//  Listen Later
//
//  Created by Greg Hepworth on 18/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct LibraryOptions: View {
  
  @EnvironmentObject private var app: AppEnvironment
  
  var body: some View {
    NavigationView {
      Form {
        Section {
          Button(action: {
            self.app.navigation.libraryIsEditing = true
            self.app.navigation.showLibraryOptions = false
          }) {
            HStack {
              Image(systemName: "square.stack.3d.up")
                .frame(width: Constants.optionsButtonIconWidth)
              Text("Reorder Library")
            }
          }
          .disabled(app.state.library.collections.isEmpty)
          RecommendationsButton()
        }
      }
      .navigationBarTitle("Library Options", displayMode: .inline)
      .navigationBarItems(
        leading:
          Button(action: {
            self.app.navigation.showLibraryOptions = false
          }) {
            Text("Close")
          },
        trailing:
          SettingsButton()
            .environmentObject(self.app)
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
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
              self.app.navigation.showLibraryOptions = false
              SharedCollectionManager.loadRecommendations()
        })
    }
  }
}
