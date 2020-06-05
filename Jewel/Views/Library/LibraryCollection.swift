//
//  LibraryCollection.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct LibraryCollection: View {
  
  var collection: CollectionState
  
  var slots: [Slot] {
    collection.slots
  }
  
  var body: some View {
    GeometryReader { geo in
      List {
        ForEach(self.slots.indices, id: \.self) { slotIndex in
          Group {
            if self.slots[slotIndex].album != nil {
              ZStack {
                LibrarySlot(slot: self.slots[slotIndex])
                NavigationLink(
                  destination: LibraryAlbumDetail(slot: self.slots[slotIndex])
                ){
                  EmptyView()
                }
              }
            } else {
              RoundedRectangle(cornerRadius: 4)
                .fill(Color.gray)
            }
          }
          .frame(height: (geo.size.height - geo.safeAreaInsets.top - geo.safeAreaInsets.bottom) / CGFloat(self.slots.count))
        }
      }
      .navigationBarTitle(self.collection.name)
    }
  }
}
