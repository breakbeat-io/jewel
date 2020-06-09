//
//  EmptyDetail.swift
//  Listen Later
//
//  Created by Greg Hepworth on 09/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct EmptyDetail: View {
  @State private var fadeIn = false
  
  var body: some View {
    VStack {
      Spacer()
      Image("primary-logo")
        .resizable()
        .scaledToFill()
        .frame(width: 150, height: 150)
        .cornerRadius(20)
        .shadow(radius: 5)
      Text("Listen Later")
        .font(.largeTitle)
      Text("Reminders and album curation for your music library")
        .font(.headline)
      Spacer()
      HStack(alignment: .firstTextBaseline) {
        Image(systemName: "chevron.left.2")
        Image(systemName: "sidebar.left")
        Text("Manage your collections from the sidebar")
      }
      .foregroundColor(.secondary)
      .padding()
    }
    .opacity(fadeIn ? 1 : 0)
    .animation(Animation.easeIn(duration: 1))
    .onAppear {
      self.fadeIn = true
    }
  }
}

