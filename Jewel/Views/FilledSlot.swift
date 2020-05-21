//
//  FilledSlot.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct FilledSlot: View {
    
    @EnvironmentObject var userData: UserData
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
                if self.userData.activeCollection.editable {
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
                .environmentObject(self.userData)
                .environmentObject(self.searchProvider)
        }
    }
}

