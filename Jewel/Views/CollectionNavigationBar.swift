//
//  HomeButtonsLeading.swift
//  Jewel
//
//  Created by Greg Hepworth on 01/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct HomeButtonsLeading: View {
    
    @EnvironmentObject var store: AppStore
    
    @State private var showOptions: Bool = false
    
    var body: some View {
        Button(action: {
            self.showOptions = true
        }) {
            Image(systemName: "slider.horizontal.3")
        }.sheet(isPresented: self.$showOptions) {
            Options(showing: self.$showOptions)
                .environmentObject(self.store)
        }
    }
}

struct HomeButtonsTrailing: View {
    
    @EnvironmentObject var store: AppStore
    
    @State private var showSearch: Bool = false
    
    var body: some View {
        Button(action: {
            self.showSearch = true
        }) {
            Image(systemName: "magnifyingglass")
        }
        .sheet(isPresented: self.$showSearch) {
            Search(showing: self.$showSearch)
                .environmentObject(self.store)
        }
    }
}
