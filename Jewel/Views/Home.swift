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
    @State private var isAddingMode: Bool = false
    
    var body: some View {
        NavigationView {
            ItemListView()
                .navigationBarTitle("Albums")
                .navigationBarItems(
                    leading: AddButton(isAddingMode: self.$isAddingMode),
                    trailing: TrailingView()
                )
        }
        .sheet(isPresented: $isAddingMode) {
            AddItemView(isAddingMode: self.$isAddingMode)
                .environmentObject(self.store)
        }
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
