//
//  FilledSlot.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct FilledSlot: View {
    
    @EnvironmentObject var wallet: SlotStore
    @EnvironmentObject var searchProvider: SearchProvider
    @State private var tapped: Int? = 0
    @State private var showSearch = false
    
    var slotId: Int
    
    var body: some View {
        NavigationLink(
            destination: AlbumDetail(slotId: self.slotId), tag: 1, selection: self.$tapped
        ) {
            AlbumCard(slotId: self.slotId)
            .onTapGesture {
                self.tapped = 1
            }
            .onLongPressGesture() {
                self.showSearch = true
            }
        }
        .sheet(isPresented: $showSearch) {
            Search(slotId: self.slotId).environmentObject(self.wallet).environmentObject(self.searchProvider)
        }
    }
}

struct FilledSlot_Previews: PreviewProvider {
    
    static let wallet = SlotStore()
    
    static var previews: some View {
        FilledSlot(slotId: 0)
    }
}
