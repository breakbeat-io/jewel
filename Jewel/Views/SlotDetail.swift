//
//  SlotDetail.swift
//  Jewel
//
//  Created by Greg Hepworth on 04/05/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import HMV

struct SlotDetail: View {
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var searchProvider: SearchProvider
    var slotId: Int
    @State private var showSearch = false
    @State private var showDeleteWarning = false
    
    private func slotDetail() -> some View {
        if userData.slots[slotId].album != nil {
            return AnyView(
                ScrollView {
                    AlbumDetail(slotId: slotId)
                }
            )
        } else {
            return AnyView(
                EmptySlot(slotId: slotId)
                .padding()
            )
        }
    }
    
    var body: some View {
        
        slotDetail()
        .navigationBarItems(trailing:
            IfLet(userData.slots[slotId].album) { album in
                HStack {
                    Button(action: {
                        self.showSearch = true
                    }) {
                        Image(systemName: "arrow.swap")
                    }
                    .padding(.leading)
                    .sheet(isPresented: self.$showSearch) {
                        Search(slotId: self.slotId)
                            .environmentObject(self.userData)
                            .environmentObject(self.searchProvider)
                    }
                    
                    Button(action: {
                        self.showDeleteWarning = true
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .padding(.leading)
                    .alert(isPresented: self.$showDeleteWarning) {
                        Alert(title: Text("Are you sure you want to delete this album from your wallet?"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .destructive(Text("Delete")) {
                                self.userData.deleteAlbumFromSlot(slotId: self.slotId)
                            })
                    }
                }
            }
        )
    }
}

struct SlotDetail_Previews: PreviewProvider {
    static var previews: some View {
        SlotDetail(slotId: 1)
    }
}
