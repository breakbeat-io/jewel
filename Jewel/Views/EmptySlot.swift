//
//  EmptySlot.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct EmptySlot: View {
    
    @EnvironmentObject var wallet: Wallet
    @State private var showSearch = false
    
    var body: some View {
        Button(action: {
            self.showSearch = true
        }) {
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 2, dash: [4, 6]))
            .overlay(
                Image(systemName: "plus.app")
                    .font(.title)
                    .foregroundColor(Color.gray)
            )
        }
        .sheet(isPresented: $showSearch) {
            Search().environmentObject(self.wallet)
        }
    }
}

struct EmptySlot_Previews: PreviewProvider {
    static var previews: some View {
        EmptySlot()
    }
}
