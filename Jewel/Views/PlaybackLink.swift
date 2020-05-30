//
//  PlaybackLink.swift
//  Jewel
//
//  Created by Greg Hepworth on 30/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct PlaybackLink: View {
    
    let url: URL
    
    var body: some View {
        Button(action: {
            UIApplication.shared.open(self.url)
        }) {
            HStack {
                Image(systemName: "play.fill")
                    .font(.headline)
                Text("Play in Apple Music")
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
