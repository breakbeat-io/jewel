//
//  EmptySlot.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct EmptySlot: View {
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var searchProvider: SearchProvider
    var slotIndex: Int
    @State private var showSearch = false
    
    var body: some View {
        HStack {
            if userData.activeCollection.editable {
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
                        .environmentObject(self.userData)
                        .environmentObject(self.searchProvider)
                }
            } else {
                RoundedRectangle(cornerRadius: 4)
                    .fill(Color.gray)
            }
        }
    }
}

struct EmptySlot_Previews: PreviewProvider {
    static let userData = UserData()
    
    static var previews: some View {
        EmptySlot(slotIndex: 1).environmentObject(userData)
    }
}
