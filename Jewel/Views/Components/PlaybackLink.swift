//
//  PlaybackControlsView.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct PlaybackLink: View {
    
    @EnvironmentObject var userData: UserData
    var slotId: Int
    
    var body: some View {
        Button(action: {
            if let url = self.userData.slots[self.slotId].album?.attributes?.url {
                UIApplication.shared.open(url)
            }
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

struct PlaybackLinkView_Previews: PreviewProvider {
    
    static var previews: some View {
        PlaybackLink(slotId: 0)
    }

}
