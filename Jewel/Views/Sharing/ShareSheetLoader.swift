//
//  ShareSheetInterstitial.swift
//  Listen Later
//
//  Created by Greg Hepworth on 06/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct ShareSheetLoader: View {
  
  let collection: Collection
  
  @State private var shareLink: URL?
  @State private var shareLinkError: Bool = false
  
  var body: some View {
    Group {
      if shareLink == nil {
        VStack {
          Image(systemName: "square.and.arrow.up")
            .font(.largeTitle)
          Text("Creating shareable link ...")
            .padding()
            .multilineTextAlignment(.center)
        }
      } else if shareLinkError {
        VStack {
          Image(systemName: "exclamationmark.triangle")
            .font(.largeTitle)
          Text("There was an error creating the shareable link, please try again later.")
            .padding()
            .multilineTextAlignment(.center)
        }
      } else {
        ShareSheet(activityItems: [shareLink!])
      }
    }
    .onAppear {
      do {
        self.shareLink = try ShareLinkProvider.generateLongLink(from: self.collection)
      } catch {
        print(error)
        self.shareLinkError = true
      }
    }
  }
}
