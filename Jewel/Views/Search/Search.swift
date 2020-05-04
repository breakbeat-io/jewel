//
//  Search.swift
//  Jewel
//
//  Created by Greg Hepworth on 23/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import HMV

struct Search: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var searchProvider: SearchProvider
    
    @State private var showCancelButton: Bool = false
    
    var slotId: Int
        
    var body: some View {
        
        VStack(alignment: .leading) {
            
            // action buttons
            HStack {
                Spacer()
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                }
            }.padding()
            
            //search box
            SearchBar()
            
            // results
            if searchProvider.results != nil {
                SearchResultsList(
                    slotId: slotId
                )
            }
            Spacer()
        }
        
        .onDisappear(perform: {
            self.searchProvider.results?.removeAll()
        })
    }
}

struct Search_Previews: PreviewProvider {
    static var previews: some View {
        Search(slotId: 1)
    }
}