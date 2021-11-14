//
//  ShareSheetInterstitial.swift
//  Listen Later
//
//  Created by Greg Hepworth on 06/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import os.log
import SwiftUI

struct ShareSheetLoader: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var collection: Collection
  
  var body: some View {
    Group {
      if app.state.navigation.shareLinkError {
        VStack {
          Image(systemName: "exclamationmark.triangle")
            .font(.largeTitle)
          Text("There was an error creating the shareable link, please try again later.")
            .padding()
            .multilineTextAlignment(.center)
        }
      } else if collection.shareLinkShort == nil {
        VStack {
          Image(systemName: "square.and.arrow.up")
            .font(.largeTitle)
          Text("Creating shareable link ...")
            .font(.body)
            .padding()
            .multilineTextAlignment(.center)
        }
      } else {
        ShareSheet(activityItems: [collection.shareLinkShort!])
      }
    }
    .onAppear {
      refreshShareLinks()
    }
    .onDisappear() {
      app.update(action: NavigationAction.showCollectionOptions(false))
    }
  }
  
  private func refreshShareLinks() {
    
    app.update(action: NavigationAction.shareLinkError(false))
    
    let newLongLink = SharedCollectionManager.generateLongLink(for: collection)
    
    if collection.shareLinkLong == nil || newLongLink != collection.shareLinkLong {
      Task {
        os_log("💎 Share Links: > Creating new Links")
        await SharedCollectionManager.setShareLinks(for: collection)
        return
      }
    }
    
    os_log("💎 Share Links: > Reusing existing links")
  }
}
