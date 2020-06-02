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
    
    private var albums: [Album?] {
        store.state.collection.slots
    }
    
    var body: some View {
        NavigationView {
            GeometryReader { geo in
                List {
                    ForEach(self.albums.indices, id: \.self) { albumIndex in
                        Group {
                            if self.albums[albumIndex] != nil {
                                ZStack {
                                    AlbumCard(album: self.albums[albumIndex]!)
                                    NavigationLink(
                                        destination: AlbumDetail(album: self.albums[albumIndex]!)
                                    ){
                                        EmptyView()
                                    }
                                }
                            } else {
                                EmptySlot(slotIndex: albumIndex)
                                    .deleteDisabled(true)
                            }
                        }
                        .frame(height: (geo.size.height - geo.safeAreaInsets.top - geo.safeAreaInsets.bottom) / CGFloat(self.albums.count))
                    }
                    .onMove { (indexSet, index) in
                        self.store.update(action: CollectionAction.moveAlbum(from: indexSet, to: index))
                    }
                    .onDelete {
                        self.store.update(action: CollectionAction.removeAlbum(slotIndexes: $0))
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
