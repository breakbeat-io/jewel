//
//  NewPlaybackLink.swift
//  Stacks
//
//  Created by Greg Hepworth on 06/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct PlaybackLink: View {
  
  let url: URL
  let platformName: String
  
  var body: some View {
    Button {
      UIApplication.shared.open(url)
    } label: {
      HStack {
        Image(systemName: "play.fill")
          .font(.headline)
        Text("Play in \(platformName)")
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
