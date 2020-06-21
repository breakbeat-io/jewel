//
//  NavBar.swift
//  Listen Later
//
//  Created by Greg Hepworth on 21/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct NavBar: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    VStack {
      HStack {
        HStack {
          Image(systemName: "chevron.left")
          //          Image(systemName: "trash")
          //          Text("Edit")
          Spacer()
        }
        .frame(width: ViewConstants.buttonWidth)
        Picker("Library", selection: $app.navigation.selectedTab) {
          Image(systemName: "music.house")
            .tag(Navigation.Tab.onrotation)
          Image(systemName: "rectangle.on.rectangle.angled")
            .tag(Navigation.Tab.library)
        }.pickerStyle(SegmentedPickerStyle())
        HStack(spacing: 0) {
          Spacer()
          Image(systemName: "plus")
            .padding(.vertical)
            .padding(.leading)
          Image(systemName: "ellipsis")
            .padding(.vertical)
            .padding(.leading)
        }
        .frame(width: ViewConstants.buttonWidth)
      }
      .padding(.horizontal)
      Rectangle()
        .frame(height: 1.0, alignment: .bottom)
        .foregroundColor(Color(UIColor.systemFill))
    }
  }
}
