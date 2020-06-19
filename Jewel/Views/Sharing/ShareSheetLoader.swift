//
//  ShareSheetInterstitial.swift
//  Listen Later
//
//  Created by Greg Hepworth on 06/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct ShareSheetLoader: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  let collectionId: UUID
  
  private var collection: Collection? {
    if collectionId == app.state.library.onRotation.id {
      return app.state.library.onRotation
    } else if let collectionIndex = app.state.library.collections.firstIndex(where: { $0.id == collectionId }) {
      return app.state.library.collections[collectionIndex]
    }
    return nil
  }
  
  var body: some View {
    Group {
      IfLet(collection) { collection in
        if collection.shareLinkShort == nil {
          VStack {
            Image(systemName: "square.and.arrow.up")
              .font(.largeTitle)
            Text("Creating shareable link ...")
              .padding()
              .multilineTextAlignment(.center)
          }
        } else if collection.shareLinkError {
          VStack {
            Image(systemName: "exclamationmark.triangle")
              .font(.largeTitle)
            Text("There was an error creating the shareable link, please try again later.")
              .padding()
              .multilineTextAlignment(.center)
          }
        } else {
          ShareSheet(activityItems: [collection.shareLinkShort!])
        }
      }
    }
    .onAppear {
      self.refreshShareLinks()
    }
    .onDisappear() {
      self.app.navigation.closeOptions()
    }
  }
  
  private func refreshShareLinks() {
    
    guard let collection = collection else {
      return
    }
    
    self.app.update(action: LibraryAction.shareLinkError(false, collectionId: collection.id))
    
    let newLongLink = SharedCollectionManager.generateLongLink(for: collection)
    
    if collection.shareLinkLong == nil || newLongLink != collection.shareLinkLong {
      print("💎 Share Links: > Creating new Links")
      SharedCollectionManager.setShareLinks(for: collection)
      return
    }
    
    print("💎 Share Links: > Reusing existing links")
  }
}
