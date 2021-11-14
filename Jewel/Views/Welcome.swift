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
  Listen Later is a reminder and album curation app for your music.

  Use your On Rotation collection to quickly store albums as you remember them to listen to soon.

  Create Collections to curate a set of albums that represent a theme or time you don't want to forget.

  Share everything with your freinds, and keep it all in your Library so you will always remember your favourite music!
  """
  private let startCollectionLabel = "Start My Collection"
  private let setCuratorNameLabel = "Set my Curator Name"
  
  var body: some View {
    RichAlert(heading: heading,
                buttons:
      VStack {
        Button {
          app.update(action: SettingsAction.firstTimeRun(false))
          app.update(action: NavigationAction.showSettings(true))
        } label: {
          Text(setCuratorNameLabel)
            .fontWeight(.light)
        }
        Divider()
          .padding(.bottom, 4)
        Button {
          app.update(action: SettingsAction.firstTimeRun(false))
        } label: {
          Text(startCollectionLabel)
            .fontWeight(.bold)
        }
      })
    {
      Text(description)
        .foregroundColor(Color.secondary)
    }
  }
}
