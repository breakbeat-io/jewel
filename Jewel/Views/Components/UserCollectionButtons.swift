//
//  UserCollectionButtons.swift
//  Listen Later
//
//  Created by Greg Hepworth on 08/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct UserCollectionButtons: View {
  
  @EnvironmentObject var environment: AppEnvironment
  
  let collectionId: UUID
  
  @State private var showOptions: Bool = false
  @State private var showSharing: Bool = false
  @State private var showShareLink: Bool = false
  @State private var showLoadRecommendationsAlert = false
  
  private var collectionEmpty: Bool {
    environment.state.library.onRotation.slots.filter( { $0.album != nil }).count == 0
  }
  
  var body: some View {
    HStack {
      Button(action: {
        self.showOptions = true
      }) {
        Image(systemName: "slider.horizontal.3")
      }
      .sheet(isPresented: self.$showOptions) {
        OptionsHome(showing: self.$showOptions)
          .environmentObject(self.environment)
      }
      .padding(.trailing)
      .padding(.vertical)
      Button(action: {
        self.showSharing = true
      }) {
        Image(systemName: "square.and.arrow.up")
      }
      .padding(.trailing)
      .padding(.vertical)
      .disabled(collectionEmpty)
      .actionSheet(isPresented: $showSharing) {
        ActionSheet(
          title: Text("Share this collection as \n \"\(environment.state.library.onRotation.name)\" by \"\(environment.state.library.onRotation.curator)\""),
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
        ShareSheetLoader(collectionId: self.collectionId)
          .environmentObject(self.environment)
      }
      Button(action: {
        self.showLoadRecommendationsAlert = true
      }) {
        Image(systemName: "square.and.arrow.down")
      }
      .padding(.trailing)
      .padding(.vertical)
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
}

