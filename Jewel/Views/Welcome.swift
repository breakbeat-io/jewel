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
  Listen Later is a place to store music you want to listen to later.

  Update albums in the On Rotation collection as you think of them so they're waiting for you when you're ready to listen.

  Create and share Collections with friends and find out what they're listening to when they share collections with you.

  Save it all to build a Library of Collections for any mood or event!
  """
  private let startCollectionLabel = "Start My Collection"
  private let setCuratorNameLabel = "Set my Curator Name"
  
  var body: some View {
    RichAlert(heading: heading,
                buttons:
      VStack {
        Button {
          self.app.update(action: SettingsAction.firstTimeRun(false))
          self.app.update(action: NavigationAction.showSettings(true))
        } label: {
          Text(self.setCuratorNameLabel)
            .fontWeight(.light)
        }
        Divider()
          .padding(.bottom, 4)
        Button {
          self.app.update(action: SettingsAction.firstTimeRun(false))
        } label: {
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
