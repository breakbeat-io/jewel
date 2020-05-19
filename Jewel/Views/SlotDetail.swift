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
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var searchProvider: SearchProvider
    var slotIndex: Int
    @State private var showSearch = false
    @State private var showEjectWarning = false
    
    private func slotDetail() -> some View {
        if userData.activeCollection.slots[slotIndex].source?.content != nil {
            return AnyView(
                ScrollView {
                    if horizontalSizeClass == .compact {
                        AlbumDetailCompact(slotIndex: slotIndex)
                    } else {
                        AlbumDetailRegular(slotIndex: slotIndex)
                    }
                }
            )
        } else {
            return AnyView(
                EmptySlot(slotIndex: slotIndex)
                    .padding()
            )
        }
    }
    
    var body: some View {
        
        slotDetail()
            .navigationBarItems(trailing:
                IfLet(userData.activeCollection.slots[slotIndex].source?.content) { album in
                    HStack {
                        if self.userData.activeCollection.editable {
                            Button(action: {
                                self.showSearch = true
                            }) {
                                Image(systemName: "arrow.swap")
                            }
                            .padding(.leading)
                            .padding(.vertical)
                            .sheet(isPresented: self.$showSearch) {
                                Search(slotIndex: self.slotIndex)
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
                                Alert(title: Text("Are you sure you want to eject this album from your collection?"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .destructive(Text("Eject")) {
                                    self.userData.ejectSourceFromSlot(slotIndex: self.slotIndex)
                                    })
                            }
                        }
                    }
                }
        )
    }
}

struct SlotDetail_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        SlotDetail(slotIndex: 1).environmentObject(userData)
    }
}
