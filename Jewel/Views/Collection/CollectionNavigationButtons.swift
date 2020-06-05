//
//  HomeButtonsLeading.swift
//  Jewel
//
//  Created by Greg Hepworth on 01/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionNavigationButtonsLeading: View {
  
  @EnvironmentObject var store: AppStore
  
  @State private var showOptions: Bool = false
  @State private var showSharing: Bool = false
  
  var body: some View {
    HStack {
      Button(action: {
        self.showSharing = true
      }) {
        Image(systemName: "square.and.arrow.up")
      }
      .padding(.trailing)
      .actionSheet(isPresented: $showSharing) {
        ActionSheet(title: Text("Share Collection"),
                    buttons: [
                      .default(Text("Add to Library")) {
                        self.store.update(action: LibraryAction.addCollection(collection: self.store.state.collection))
                        self.store.update(action: CollectionAction.toggleActive)
                      },
                      .cancel()
                    ])
      }
      Button(action: {
        self.showOptions = true
      }) {
        Image(systemName: "slider.horizontal.3")
      }
      .padding(.trailing)
      .sheet(isPresented: self.$showOptions) {
        Options(showing: self.$showOptions)
          .environmentObject(self.store)
      }
    }
    .padding(.vertical)
  }
}

struct CollectionNavigationButtonsTrailing: View {
  
  var body: some View {
    HStack {
      EditButton()
        .padding(.leading)
      Button(action: {
        store.update(action: CollectionAction.toggleActive)
      }) {
        Image(systemName: "square.stack" )
      }
      .padding(.leading)
    }
    .padding(.vertical)
  }
}
