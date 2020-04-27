//
//  FilledSlot.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct FilledSlot: View {
    
    @EnvironmentObject var wallet: WalletStore
    @State private var selection: Int? = 0
    @State private var showSearch = false
    
    var slot: Slot
    
    var body: some View {
        Unwrap(slot.album?.attributes) { albumAttributes in
            NavigationLink(
                destination: ReleaseDetail (
                    albumAttributes: albumAttributes
                ), tag: 1, selection: self.$selection
            ) {
                ReleaseListItem (
                    albumAttributes: albumAttributes
                )
                .shadow(radius: 3)
                .onTapGesture {
                    self.selection = 1
                }
                .onLongPressGesture() {
                    self.showSearch = true
                }
            }
        }
        .sheet(isPresented: $showSearch) {
            Search(slotId: self.slot.id).environmentObject(self.wallet)
        }
    }
}

struct FilledSlot_Previews: PreviewProvider {
    
    static let wallet = WalletStore()
    
    static var previews: some View {
        FilledSlot(slot: wallet.slots[0])
    }
}
