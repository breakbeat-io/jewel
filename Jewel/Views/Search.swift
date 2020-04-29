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
    @EnvironmentObject var wallet: WalletViewModel
    @EnvironmentObject var searchProvider: SearchProvider
    
    @State private var showCancelButton: Bool = false
    @State private var showingAlert = false
    
    var slotId: Int
        
    var body: some View {
        
        VStack(alignment: .leading) {
            
            // action buttons
            HStack {
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Cancel")
                        .fontWeight(.bold)
                }
                Spacer()
                Button(action: {
                    self.showingAlert = true
                }) {
                    Image(systemName: "square.and.arrow.down.on.square")
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
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Do you want to load our recommendations?"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .default(Text("Load").bold()) {
                    self.wallet.loadRecommendations()
                })
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
