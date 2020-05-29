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
    
    @State private var title: String = ""
    @State private var artist: String = ""
    @Binding var showSearch: Bool
    
    var body: some View {
        NavigationView {
            VStack{
                SearchBar()
                Spacer()
            }
            .navigationBarTitle("Search")
            .navigationBarItems(
                leading: Button(action: {
                    self.showSearch = false
                }) {
                    Text("Cancel")
                },
                trailing: Button(action: {
                    let album = Album(
                        title: self.title,
                        artist: self.artist
                    )
                    self.store.update(action: .addAlbum(album: album))
                    self.showSearch = false
                }) {
                    Text("Save")
                }
                .disabled(title.isEmpty)
            )
        }
    }
}

//struct AddItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        AddItemView()
//    }
//}
