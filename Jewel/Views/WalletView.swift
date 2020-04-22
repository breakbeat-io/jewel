//
//  CircleImage.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import Grid

struct WalletView: View {
    
    @EnvironmentObject var wallet: Wallet
    @State private var showingAlert = false
    
    var body: some View {
        NavigationView {
            List(self.wallet.slots) { slot in
                if slot.album == nil {
                    EmptySlot()
                } else {
                    FilledSlot(slot: slot)
                }
            }
            .environment(\.defaultMinListRowHeight, 75)
            .padding(6)
            .navigationBarTitle(Text("My Releases"))
            .navigationBarItems(trailing:
                Button(action: {
                    self.showingAlert = true
                }) {
                    Text("Load")
                }
            )
        }
        .statusBar(hidden: true)
        .accentColor(.black)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Do you want to load the example albums?"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .default(Text("Load").bold()) {
                    self.wallet.loadExampleWallet()
                })
        }
    }
}

struct CircleImage_Previews: PreviewProvider {
    static let wallet = Wallet()
    
    static var previews: some View {
        WalletView().environmentObject(wallet)
    }
}
