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
    
    @State private var showUserSettings = false
    
    private func slotViewForId(slotId: Int) -> some View {
        if wallet.slots[slotId].album == nil {
            return AnyView(EmptySlot(slotId: slotId))
        } else {
            return AnyView(FilledSlot(slotId: slotId))
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                List(self.wallet.slots) { slot in
                    self.slotViewForId(slotId: slot.id)
                        .frame(height: (geo.size.height - geo.safeAreaInsets.top - geo.safeAreaInsets.bottom) / CGFloat(self.wallet.slots.count))
                }
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                }
                .navigationBarTitle("My Wallet")
                .navigationBarItems(trailing:
                    Button(action: {
                        self.showUserSettings = true
                    }) {
                        Image(systemName: "gear")
                            .padding()
                    }
                )
                    .sheet(isPresented: self.$showUserSettings) {
                    EmptyView()
                }
            }
        }
        .statusBar(hidden: true)
    }
}

struct Wallet_Previews: PreviewProvider {
    static let wallet = SlotStore()
    
    static var previews: some View {
        Wallet().environmentObject(wallet)
    }
}
