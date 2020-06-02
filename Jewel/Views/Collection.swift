//
//  Home.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct Collection: View {
    
    @EnvironmentObject var store: AppStore
    
    private var slots: [Slot] {
        store.state.collection.slots
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                List {
                    ForEach(self.slots.indices, id: \.self) { slotIndex in
                        Group {
                            if self.slots[slotIndex].album != nil {
                                ZStack {
                                    AlbumCard(album: self.slots[slotIndex].album!)
                                    NavigationLink(
                                        destination: AlbumDetail(album: self.slots[slotIndex].album!)
                                    ){
                                        EmptyView()
                                    }
                                }
                            } else {
                                EmptySlot(slotIndex: slotIndex)
                                    .deleteDisabled(true)
                            }
                        }
                        .frame(height: (geo.size.height - geo.safeAreaInsets.top - geo.safeAreaInsets.bottom) / CGFloat(self.slots.count))
                    }
                    .onMove { (indexSet, index) in
                        self.store.update(action: CollectionAction.moveSlot(from: indexSet, to: index))
                    }
                    .onDelete {
                        self.store.update(action: CollectionAction.removeAlbumFromSlot(slotIndexes: $0))
                    }
                }
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                }
                .navigationBarTitle(self.store.state.collection.name)
                .navigationBarItems(
                    leading: HomeButtonsLeading(),
                    trailing: HomeButtonsTrailing()
                )
            }
        }
    }
}
