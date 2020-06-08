//
//  UserCollectionButtons.swift
//  Listen Later
//
//  Created by Greg Hepworth on 08/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct UserCollectionButtons: View {
  
  @EnvironmentObject var store: AppStore
  
  @State private var showOptions: Bool = false
  @State private var showSharing: Bool = false
  @State private var showShareLink: Bool = false
  
  private var collectionEmpty: Bool {
    store.state.library.userCollection.slots.filter( { $0.album != nil }).count == 0
  }
  
  var body: some View {
    HStack {
      if store.state.library.userCollectionActive {
        Button(action: {
          self.showOptions = true
        }) {
          Image(systemName: "slider.horizontal.3")
        }
        .sheet(isPresented: self.$showOptions) {
          OptionsHome(showing: self.$showOptions)
            .environmentObject(self.store)
        }
        .padding(.trailing)
        Button(action: {
          self.showSharing = true
        }) {
          Image(systemName: "square.and.arrow.up")
        }
        .disabled(collectionEmpty)
        .actionSheet(isPresented: $showSharing) {
          ActionSheet(
            title: Text("Share this collection as \n \"\(store.state.library.userCollection.name)\" by \"\(store.state.library.userCollection.curator)\""),
            buttons: [
              .default(Text("Send share link")) {
                self.showShareLink = true
              },
              .default(Text("Add to my Collection Library")) {
                self.store.update(action: LibraryAction.addSharedCollection(collection: self.store.state.library.userCollection))
                self.store.update(action: LibraryAction.makeUserCollectionActive(activeState: false))
              },
              .default(Text("Update Collection Name")) {
                self.showOptions = true
              },
              .cancel()
          ])
        }
        .sheet(isPresented: self.$showShareLink) {
          ShareSheetLoader()
            .environmentObject(self.store)
        }
      }
    }
    
  }
}

