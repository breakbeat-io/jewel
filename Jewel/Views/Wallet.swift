//
//  CircleImage.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct Wallet: View {
    
    @EnvironmentObject var wallet: SlotStore
    
    var body: some View {
        NavigationView {
            List(self.wallet.slots) { slot in
                if slot.album == nil {
                    EmptySlot(slotId: slot.id)
                        .frame(height: 60)
                } else {
                    FilledSlot(slotId: slot.id)
                        .frame(height: 60)
                }
            }
            .onAppear {
                UITableView.appearance().separatorStyle = .none
            }
            .navigationBarTitle("", displayMode: .inline)
            .navigationBarHidden(true)
        }
    }
}

struct Wallet_Previews: PreviewProvider {
    static let wallet = SlotStore()
    
    static var previews: some View {
        Wallet().environmentObject(wallet)
    }
}
