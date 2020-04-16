//
//  PlaybackControlsView.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct PlaybackControls: View {
    var body: some View {
        HStack {
            Image(systemName: "shuffle")
            Spacer()
            Image(systemName: "backward.end.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
            Spacer()
            Image(systemName: "playpause.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60)
            Spacer()
            Image(systemName: "forward.end.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30)
            Spacer()
            Image(systemName: "repeat")
        }
        .padding(50)
    }
}

struct PlaybackControlsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaybackControls()
    }
}
