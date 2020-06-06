//
//  NewPlaybackLink.swift
//  Listen Later
//
//  Created by Greg Hepworth on 06/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct PlaybackLink: View {
  
  let url: URL
  let platformName: String
  
  var body: some View {
    Button(action: {
      UIApplication.shared.open(self.url)
    }) {
      HStack {
        Image(systemName: "play.fill")
          .font(.headline)
        Text("Play in \(self.platformName)")
          .font(.headline)
      }
      .padding()
      .foregroundColor(.primary)
      .cornerRadius(40)
      .overlay(
        RoundedRectangle(cornerRadius: 40)
          .stroke(Color.primary, lineWidth: 2)
      )
    }
  }
}
