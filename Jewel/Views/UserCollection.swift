//
//  Home.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct UserCollection: View {
  
  @EnvironmentObject var store: AppStore
  
  @Binding var isEditing: Bool
  
  private var slots: [Slot] {
    store.state.library.userCollection.slots
  }
  
  var body: some View {
    GeometryReader { geo in
      VStack {
        List {
          ForEach(self.slots.indices, id: \.self) { slotIndex in
            Group {
              if self.slots[slotIndex].album != nil {
                ZStack {
                  IfLet(self.slots[slotIndex].album?.attributes) { attributes in
                    AlbumCard(albumName: attributes.name, albumArtist: attributes.artistName, albumArtwork: attributes.artwork.url(forWidth: 1000))
                  }
                  NavigationLink(
                    destination: ObservedAlbumDetail(slotId: slotIndex)
                  ){
                    EmptyView()
                  }
                }
              } else {
                EmptySlotCard(slotIndex: slotIndex)
                  .deleteDisabled(true)
              }
            }
            .frame(height: (geo.size.height - geo.safeAreaInsets.bottom) / CGFloat(self.slots.count))
          }
          .onMove { (indexSet, index) in
            self.store.update(action: LibraryAction.moveSlot(from: indexSet, to: index))
          }
          .onDelete {
            self.store.update(action: LibraryAction.removeAlbumFromSlot(slotIndexes: $0))
          }
        }
        .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
      }
      .onAppear {
        self.store.update(action: LibraryAction.setActiveState(activeState: true))
        self.isEditing = false
      }
      
    }
  }
}
