//
//  Home.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var store: AppStore
    
    @State private var showSearch: Bool = false
    @State private var showOptions: Bool = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(store.state.collection.albums) { album in
                    NavigationLink(
                        destination: AlbumDetail(album: album)
                    ) {
                        AlbumCard(album: album)
                    }
                }
                .onDelete {
                    self.store.update(action: CollectionAction.removeAlbum(at: $0))
                }
            }
            .navigationBarTitle(store.state.collection.name)
            .navigationBarItems(
                leading: Button(action: {
                    self.showOptions = true
                }) {
                    Image(systemName: "slider.horizontal.3")
                }.sheet(isPresented: self.$showOptions) {
                    Options(showing: self.$showOptions)
                        .environmentObject(self.store)
                },
                trailing: Button(action: {
                    self.showSearch = true
                }) {
                    Image(systemName: "magnifyingglass")
                }
                .sheet(isPresented: $showSearch) {
                    Search(showing: self.$showSearch)
                        .environmentObject(self.store)
                }
            )
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
