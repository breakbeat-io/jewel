//
//  CollectionReceived.swift
//  Listen Later
//
//  Created by Greg Hepworth on 26/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionReceived: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    FullOverlay(heading: "Shared Collection Received",
            buttons: CollectionReceivedButtons()) {
              IfLet(app.state.library.cuedCollection) { cuedCollection in
                VStack {
                  Text("Would you like to add the following collection to your Collection Library?")
                    .padding(.bottom, 30)
                    .fixedSize(horizontal: false, vertical: true)
                  Rectangle()
                    .padding()
                    .foregroundColor(.clear)
                    .cornerRadius(Constants.cardCornerRadius)
                    .overlay(
                      VStack {
                        Text(cuedCollection.collectionName)
                          .font(.title)
                          .fontWeight(.bold)
                        Text("by \(cuedCollection.collectionCurator)")
                          .font(.subheadline)
                          .fontWeight(.light)
                          .foregroundColor(.secondary)
                      }
                      .frame(minWidth: 0, maxWidth: .infinity)
                      .padding()
                      .background(Color(UIColor.secondarySystemBackground))
                      .cornerRadius(Constants.cardCornerRadius)
                      , alignment: .center)
                }
              }
    }
  }
}


struct CollectionReceivedButtons: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    HStack {
      Spacer()
      Button(action: {
        self.app.update(action: LibraryAction.uncueSharedCollection)
      }, label: {
        Text("Cancel")
      })
      Spacer()
      Button(action: {
        self.app.navigation.selectedTab = .library
        SharedCollectionManager.expandShareableCollection(shareableCollection: self.app.state.library.cuedCollection!)
        self.app.update(action: LibraryAction.uncueSharedCollection)
      }, label: {
        Text("Add")
          .fontWeight(.bold)
      })
      Spacer()
    }
  }
}
