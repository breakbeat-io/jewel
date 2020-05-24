//
//  EmptySlot.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct EmptySlot: View {
    
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var collections: Collections
    @EnvironmentObject var searchProvider: SearchProvider
    
    @State private var showSearch = false
    
    var slotIndex: Int
    
    var body: some View {
        HStack {
            if collections.activeCollection.editable {
                Button(action: {
                    self.showSearch = true
                }) {
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(
                            Color.gray,
                            style: StrokeStyle(lineWidth: 2, dash: [4, 6])
                    )
                        .overlay(
                            Image(systemName: "plus")
                                .font(.headline)
                                .foregroundColor(Color.gray)
                    )
                }
                .sheet(isPresented: $showSearch) {
                    Search(slotIndex: self.slotIndex)
                        .environmentObject(self.preferences)
                        .environmentObject(self.collections)
                        .environmentObject(self.searchProvider)
                }
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray)
            }
        }
    }
}
