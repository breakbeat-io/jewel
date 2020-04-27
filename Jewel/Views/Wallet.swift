//
//  CircleImage.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct Wallet: View {
    
    @EnvironmentObject var wallet: WalletStore
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(self.wallet.slots) { slot in
                    if slot.album == nil {
                        EmptySlot(slotId: slot.id).environmentObject(self.wallet)
                    } else {
                        FilledSlot(slot: slot).environmentObject(self.wallet)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
            .navigationBarTitle(Text("My Collection"))
        }
        
        .statusBar(hidden: true)
        .accentColor(.black)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static let wallet = WalletStore()
    
    static var previews: some View {
        Wallet().environmentObject(wallet)
    }
}
