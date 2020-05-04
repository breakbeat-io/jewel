//
//  Wallet.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct Wallet: View {
    
    @EnvironmentObject var userData: UserData
    
    @State private var showUserSettings = false
    
    private func slotViewForId(slotId: Int) -> some View {
        if userData.slots[slotId].album == nil {
            return AnyView(EmptySlot(slotId: slotId))
        } else {
            return AnyView(FilledSlot(slotId: slotId))
        }
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                List(self.userData.slots) { slot in
                    self.slotViewForId(slotId: slot.id)
                        .frame(height: (geo.size.height - geo.safeAreaInsets.top - geo.safeAreaInsets.bottom) / CGFloat(self.userData.slots.count))
                }
                .sheet(isPresented: self.$showUserSettings) {
                    UserSettings().environmentObject(self.userData)
                }
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                }
                .navigationBarTitle(self.userData.walletName)
                .navigationBarItems(trailing:
                    Button(action: {
                        self.showUserSettings = true
                    }) {
                        Image(systemName: "gear")
                    }
                )
            }
        }
        .statusBar(hidden: true)
    }
}

struct Wallet_Previews: PreviewProvider {
    static let userData = UserData()
    
    static var previews: some View {
        Wallet().environmentObject(userData)
    }
}
