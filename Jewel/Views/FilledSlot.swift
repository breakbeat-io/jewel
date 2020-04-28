//
//  FilledSlot.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct FilledSlot: View {
    
    @EnvironmentObject var wallet: WalletViewModel
    @State private var tapped: Int? = 0
    @State private var showSearch = false
    
    var slotId: Int
    
    var body: some View {
        NavigationLink(
            destination: AlbumDetail(slotId: self.slotId), tag: 1, selection: self.$tapped
        ) {
            AlbumCard(slotId: self.slotId)
            .environmentObject(self.wallet)
            .shadow(radius: 3)
            .onTapGesture {
                self.tapped = 1
            }
            .onLongPressGesture() {
                self.showSearch = true
            }
        }
        .sheet(isPresented: $showSearch) {
            Search(slotId: self.slotId).environmentObject(self.wallet)
        }
    }
}

struct FilledSlot_Previews: PreviewProvider {
    
    static let wallet = WalletViewModel()
    
    static var previews: some View {
        FilledSlot(slotId: 0)
    }
}
