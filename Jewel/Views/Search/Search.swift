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

    @Binding var showSearch: Bool
    
    var body: some View {
        NavigationView {
            VStack{
                SearchBar()
                Spacer()
                SearchResults()
            }
            .navigationBarTitle("Search")
            .navigationBarItems(
                trailing: Button(action: {
                    self.showSearch = false
                }) {
                    Text("Cancel")
                }
            )
        }
    }
}

//struct AddItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemView()
//    }
//}
