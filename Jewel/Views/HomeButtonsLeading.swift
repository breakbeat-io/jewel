//
//  HomeButtonsLeading.swift
//  Jewel
//
//  Created by Greg Hepworth on 20/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct HomeButtonsLeading: View {
    
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var collections: Collections
    
    @State private var showOptions = false
    
    var body: some View {
        Button(action: {
            self.showOptions = true
        }) {
            Image(systemName: "slider.horizontal.3")
        }
        .sheet(isPresented: self.$showOptions) {
            Options()
                .environmentObject(self.preferences)
                .environmentObject(self.collections)
        }
        .padding(.trailing)
        .padding(.vertical)
    }
}
