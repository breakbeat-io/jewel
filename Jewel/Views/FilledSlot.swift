//
//  FilledSlot.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct FilledSlot: View {
    
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var collections: Collections
    @EnvironmentObject var searchProvider: SearchProvider
    
    @State private var tapped: Int? = 0
    @State private var showSearch = false
    
    var slotIndex: Int
    
    var body: some View {
        ZStack {
            SourceCard(slotIndex: slotIndex)
                .onTapGesture {
                    self.tapped = 1
            }
            .onLongPressGesture() {
                if self.collections.activeCollection.editable {
                    self.showSearch = true
                }
            }
            NavigationLink(
                destination: SlotDetail(slotIndex: slotIndex),
                tag: 1,
                selection: $tapped
            ){
                EmptyView()
            }
        }
        .sheet(isPresented: $showSearch) {
            Search(slotIndex: self.slotIndex)
                .environmentObject(self.preferences)
                .environmentObject(self.collections)
                .environmentObject(self.searchProvider)
        }
    }
}

