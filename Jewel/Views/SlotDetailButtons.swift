//
//  SlotDetailButtons.swift
//  Jewel
//
//  Created by Greg Hepworth on 20/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct SlotDetailButtons: View {
    
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var searchProvider: SearchProvider
    
    @State private var showSearch = false
    @State private var showEjectWarning = false
    
    var slotIndex: Int
    private var showButtons: Bool {
        userData.activeCollection.slots[slotIndex].source?.content != nil && userData.activeCollection.editable
    }
    
    var body: some View {
        HStack {
            if showButtons {
                Button(action: {
                    self.showSearch = true
                }) {
                    Image(systemName: "arrow.swap")
                }
                .padding(.leading)
                .padding(.vertical)
                .sheet(isPresented: self.$showSearch) {
                    Search(slotIndex: self.slotIndex)
                        .environmentObject(self.preferences)
                        .environmentObject(self.userData)
                        .environmentObject(self.searchProvider)
                }
                Button(action: {
                    self.showEjectWarning = true
                }) {
                    Image(systemName: "eject")
                }
                .padding(.leading)
                .padding(.vertical)
                .alert(isPresented: self.$showEjectWarning) {
                    Alert(title: Text("Are you sure you want to eject this album from your collection?"),
                          primaryButton: .cancel(Text("Cancel")),
                          secondaryButton: .destructive(Text("Eject")
                          ){
                            self.userData.ejectSourceFromSlot(slotIndex: self.slotIndex)
                        }
                    )
                }
            }
        }
    }
}
