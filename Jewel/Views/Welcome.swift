//
//  Welcome.swift
//  Listen Later
//
//  Created by Greg Hepworth on 09/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Welcome: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private let heading = "Welcome!"
  private let description = """
  Listen Later is a place to store albums you want to listen to later.

  Add and remove albums from any of 8 slots as you think of them, and they'll be there waiting for you when you're ready to listen!

  Send your collection to friends and find out what they're listening to by asking them to send their collection to you.

  Build a Collection Library of your and your friends collections for easy play back later!
  """
  private let startCollectionLabel = "Start My Collection"
  private let setCuratorNameLabel = "Set my Curator Name"
  
  var body: some View {
    FullOverlay(heading: heading,
                buttons:
      VStack {
        Button(action: {
          self.app.update(action: OptionsAction.firstTimeRun(false))
          self.app.navigation.showSettings = true
        }) {
          Text(self.setCuratorNameLabel)
            .fontWeight(.light)
        }
        Divider()
          .padding(.bottom, 4)
        Button(action: {
          self.app.update(action: OptionsAction.firstTimeRun(false))
        }) {
          Text(self.startCollectionLabel)
            .fontWeight(.bold)
        }
      })
    {
      Text(self.description)
        .foregroundColor(Color.secondary)
    }
  }
}
