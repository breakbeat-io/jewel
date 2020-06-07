//
//  ShareSheetInterstitial.swift
//  Listen Later
//
//  Created by Greg Hepworth on 06/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct ShareSheetLoader: View {
  
  @EnvironmentObject var store: AppStore
  
  private var collection: Collection {
    store.state.collection
  }
  
  var body: some View {
    Group {
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
    .onAppear {
      self.refreshShareLinks()
    }
  }
  
  private func refreshShareLinks() {
    
    self.store.update(action: CollectionAction.setShareLinkError(errorState: false))
    
    let newLongLink = ShareLinkProvider.generateLongLink(for: collection)
    
    if collection.shareLinkLong == nil || newLongLink != collection.shareLinkLong {
      print("Creating new Links")
      ShareLinkProvider.setShareLinks(for: collection)
      return
    }
    
    print("Reusing existing links")
  }
}
