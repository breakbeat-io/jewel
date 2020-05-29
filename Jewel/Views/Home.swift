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
    
    var body: some View {
        NavigationView {
            ItemListView()
                .navigationBarTitle("Albums")
                .navigationBarItems(
                    leading: Button(action: {
                        self.showSearch = true
                    }) {
                        Image(systemName: "plus")
                    },
                    trailing: TrailingView()
                )
        }
        .sheet(isPresented: $showSearch) {
            Search(showSearch: self.$showSearch)
                .environmentObject(self.store)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
