//
//  NewHome.swift
//  Listen Later
//
//  Created by Greg Hepworth on 21/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct ViewConstants {
  static let buttonWidth: CGFloat = 70
}

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
          if app.navigation.selectedTab == .onrotation {
            OnRotation()
          }
          if app.navigation.selectedTab == .library {
            CollectionLibrary()
          }
        }
        .background(Color(UIColor.systemBackground))
      }
    }
  }
}

struct Home_Previews: PreviewProvider {
  static var previews: some View {
    Home()
  }
}
