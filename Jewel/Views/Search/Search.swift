//
//  Search.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Search: View {
    
    @EnvironmentObject private var store: AppStore
    
    @Binding var showing: Bool
    
    var body: some View {
        NavigationView {
            VStack{
                SearchBar()
                Spacer()
                SearchResults(showing: self.$showing)
            }
            .navigationBarTitle("Search")
            .navigationBarItems(
                trailing: Button(action: {
                    self.showing = false
                }) {
                    Text("Cancel")
                }
            )
        }
    }
}
