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
    
    var slotId: Int
    
    var body: some View {
        ZStack {
            AlbumCard(album: userData.slots[slotId].album!)
            .onTapGesture {
                self.tapped = 1
            }
            .onLongPressGesture() {
                self.showSearch = true
            }
            NavigationLink(
                destination: AlbumDetail(slotId: self.slotId),
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
    
    static let wallet = UserData()
    
    static var previews: some View {
        FilledSlot(slotId: 0)
    }
}
