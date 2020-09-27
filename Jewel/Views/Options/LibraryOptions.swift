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
          RecommendationsButton()
        }
      }
      .navigationBarTitle("Library Options", displayMode: .inline)
      .navigationBarItems(
        leading:
        Button {
          self.app.update(action: NavigationAction.showLibraryOptions(false))
        } label: {
          Text("Close")
        }
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct RecommendationsButton: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var showLoadRecommendationsAlert: Binding<Bool> { Binding (
    get: { self.app.state.navigation.showLoadRecommendationsAlert },
    set: { if self.app.state.navigation.showLoadRecommendationsAlert { self.app.update(action: NavigationAction.showLoadRecommendationsAlert($0)) } }
  )}
  
  var body: some View {
    Button {
      self.app.update(action: NavigationAction.showLoadRecommendationsAlert(true))
    } label: {
      HStack {
        Image(systemName: "square.and.arrow.down")
          .frame(width: Constants.optionsButtonIconWidth)
        Text("Load Recommendations")
      }
    }
    .alert(isPresented: showLoadRecommendationsAlert) {
      Alert(title: Text("Add our current Recommended Collection?"),
            message: Text("Every three months we publish a Collection of new and classic albums for you to listen to."),
            primaryButton: .default(Text("Cancel")),
            secondaryButton: .default(Text("Add").fontWeight(.bold)) {
              self.app.update(action: NavigationAction.showLibraryOptions(false))
              SharedCollectionManager.loadRecommendations()
        })
    }
  }
}
