//
//  PlaybackControlsView.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct PlaybackControls: View {
    
    @EnvironmentObject var wallet: WalletViewModel
    var slotId: Int
    
    var body: some View {
        Button(action: {
            UIApplication.shared.open(self.wallet.slots[self.slotId].album!.attributes!.url)
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
    static let wallet = WalletViewModel()
    
    static var previews: some View {
        PlaybackControls(slotId: 0)
    }
}
