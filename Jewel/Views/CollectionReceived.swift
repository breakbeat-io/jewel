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
    RichAlert(heading: "Shared Collection Received", buttons: CollectionReceivedButtons()) {
      if let cuedCollection = app.state.library.cuedCollection {
        VStack {
          Text("Would you like to add the following collection to your Collection Library?")
            .foregroundColor(Color.secondary)
            .padding(.bottom, 30)
          VStack {
            Text(cuedCollection.collectionName)
              .font(.headline)
              .padding(.bottom)
            Text("by \(cuedCollection.collectionCurator)")
              .font(.subheadline)
              .foregroundColor(.secondary)
          }
          .multilineTextAlignment(.center)
          .padding()
          .overlay(
            RoundedRectangle(cornerRadius: 4)
              .stroke(Color.secondary, lineWidth: 1)
          )
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
      Button {
        app.update(action: LibraryAction.uncueSharedCollection)
      } label: {
        Text("Cancel")
      }
      Spacer()
      Button {
        Task {
          app.update(action: NavigationAction.switchTab(to: .library))
          await SharedCollectionManager.expandShareableCollection(shareableCollection: app.state.library.cuedCollection!)
          app.update(action: LibraryAction.uncueSharedCollection)
          app.update(action: NavigationAction.setActiveCollectionId(collectionId: app.state.library.collections.first!.id))
          app.update(action: NavigationAction.showCollection(true))
        }
      } label: {
        Text("Add")
          .fontWeight(.bold)
      }
      Spacer()
    }
  }
}
