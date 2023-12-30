//
//  NewHome.swift
//  Stacks
//
//  Created by Greg Hepworth on 21/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import MusicKit

struct Home: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    ZStack {
      Color(UIColor.systemBackground)
        .edgesIgnoringSafeArea(.bottom)
      Color(UIColor.secondarySystemBackground)
        .edgesIgnoringSafeArea(.top)
      VStack(spacing: 0) {
        NavBar()
        VStack {
          if app.state.navigation.selectedTab == .onRotation {
            OnRotation()
              .transition(.move(edge: .leading))
              .animation(.easeOut)
          }
          if app.state.navigation.selectedTab == .library {
            StackLibrary()
              .transition(.move(edge: .trailing))
              .animation(.easeOut)
          }
        }
        .background(Color(UIColor.systemBackground))
      }
      .disabled(app.state.settings.firstTimeRun)
      .blur(radius: app.state.settings.firstTimeRun ? 10 : 0)
      if app.state.settings.firstTimeRun {
        Welcome()
      }
    }
  }
}
