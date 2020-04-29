//
//  CircleImage.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct Wallet: View {
    
    @EnvironmentObject var wallet: WalletViewModel
    
    var body: some View {
        NavigationView {
            VStack {
                ForEach(self.wallet.slots) { slot in
                    if slot.album == nil {
                        EmptySlot(slotId: slot.id)
                    } else {
                        FilledSlot(slotId: slot.id)
                    }
                }
            }
            .padding()
            .navigationBarTitle("", displayMode: .inline)
        }
    }
}

struct Wallet_Previews: PreviewProvider {
    static let wallet = WalletViewModel()
    
    static var previews: some View {
        Wallet().environmentObject(wallet)
    }
}
