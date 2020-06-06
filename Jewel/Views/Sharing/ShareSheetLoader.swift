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
      self.generateShareLinks()
    }
  }
  
  private func generateShareLinks() {
    self.store.update(action: CollectionAction.setShareLinkError(errorState: false))
    
    if self.collection.shareLinkLong == nil {
      print("No links found, generating")
      guard let shareLinkLong = ShareLinkProvider.getLongLink(for: self.collection) else {
        return
      }
      self.store.update(action: CollectionAction.setShareLinkLong(shareLinkLong: shareLinkLong))
      ShareLinkProvider.setShortLink(for: shareLinkLong)
    } else {
      guard let newLongLink = ShareLinkProvider.getLongLink(for: self.collection) else {
        return
      }
      
      if newLongLink == self.collection.shareLinkLong {
        print("Long link hasn't changed, reusing short link")
      } else {
        print("Long link changed, regenerating links")
        self.store.update(action: CollectionAction.setShareLinkLong(shareLinkLong: newLongLink))
        ShareLinkProvider.setShortLink(for: newLongLink)
      }
    }
  }
}
