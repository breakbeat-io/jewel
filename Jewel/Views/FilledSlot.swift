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
    var slotId: Int
    @State private var tapped: Int? = 0
    @State private var showSearch = false
    
    var body: some View {
        
        ZStack {
            AlbumCard(slotId: self.slotId)
            .onTapGesture {
                self.tapped = 1
            }
            .onLongPressGesture() {
                self.showSearch = true
            }
            NavigationLink(
                destination: SlotDetail(slotId: self.slotId),
                tag: 1,
                selection: self.$tapped
            ){
                EmptyView()
            }
        }
        .sheet(isPresented: $showSearch) {
            Search(slotId: self.slotId)
                .environmentObject(self.userData)
                .environmentObject(self.searchProvider)
        }
    }
}

struct FilledSlot_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        FilledSlot(slotId: 0).environmentObject(userData)
    }
}
