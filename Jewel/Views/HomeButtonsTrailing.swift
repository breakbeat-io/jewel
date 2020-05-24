//
//  HomeButtons.swift
//  Jewel
//
//  Created by Greg Hepworth on 20/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct HomeButtonsTrailing: View {
    
    @EnvironmentObject var collections: Collections
    
    @State private var showShareSheet = false
    
    private var collectionEmpty: Bool {
        collections.activeCollection.slots.filter( { $0.source != nil }).count == 0
    }
    private var sharedCollectionEmpty: Bool {
        collections.sharedCollection.slots.filter( { $0.source != nil }).count == 0
    }
    
    var body: some View {
        HStack {
            Button(action: {
                self.showShareSheet = true
            }) {
                Image(systemName: "square.and.arrow.up")
            }
            .padding(.leading)
            .padding(.vertical)
            .disabled(collectionEmpty)
            .sheet(isPresented: self.$showShareSheet) {
                ShareSheetInterstitial().environmentObject(self.collections)
            }
            Button(action: {
                self.collections.userCollectionActive.toggle()
            }) {
                Image(systemName: "arrow.2.squarepath")
            }
            .padding(.leading)
            .padding(.vertical)
            .disabled(sharedCollectionEmpty)
            
        }
        
    }
}

