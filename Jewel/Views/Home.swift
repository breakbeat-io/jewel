//
//  NewHome.swift
//  Listen Later
//
//  Created by Greg Hepworth on 21/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Home: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var receivedCollectionCued: Binding<Bool> {
    Binding (
      get: { self.app.state.library.cuedCollection != nil },
      set: { _ = $0 }
    )
  }
  private var showingRichAlert: Bool {
    app.state.settings.firstTimeRun || receivedCollectionCued.wrappedValue
  }
  
  var body: some View {
    ZStack {
      Color(UIColor.systemBackground)
        .edgesIgnoringSafeArea(.bottom)
      Color(UIColor.secondarySystemBackground)
        .edgesIgnoringSafeArea(.top)
      VStack(spacing: 0) {
        NavBar()
        VStack {
          if self.app.state.navigation.selectedTab == .onRotation {
            OnRotation()
              .transition(.move(edge: .leading))
              .animation(.easeOut)
          }
          if self.app.state.navigation.selectedTab == .library {
            CollectionLibrary()
              .transition(.move(edge: .trailing))
              .animation(.easeOut)
          }
        }
        .background(Color(UIColor.systemBackground))
      }
      .disabled(showingRichAlert)
      .blur(radius: showingRichAlert ? 10 : 0)
      if app.state.settings.firstTimeRun {
        Welcome()
      }
      if self.receivedCollectionCued.wrappedValue {
        CollectionReceived()
      }
    }
  }
}
