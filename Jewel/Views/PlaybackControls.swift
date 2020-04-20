//
//  PlaybackControlsView.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct PlaybackControls: View {
    var playbackUrl: String
    
    var body: some View {
        Button(action: {
            // TODO: change this to take an <URL> directly so that the partent view can hide the button if the <URL> is nil
            guard let url = URL(string: self.playbackUrl) else {
                return
            }
            UIApplication.shared.open(url)
        }) {
            HStack {
                Image(systemName: "play.fill")
                    .font(.headline)
                Text("Play in Apple Music")
                    .font(.headline)
                    
            }
            .padding()
            .foregroundColor(.black)
            .cornerRadius(40)
            .overlay(
                RoundedRectangle(cornerRadius: 40)
                    .stroke(Color.black, lineWidth: 2)
                    .shadow(radius: 5)
            )
        }
    }
}

struct PlaybackControlsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackControls(playbackUrl: releasesData[0].appleMusicShareURL)
    }
}
