//
//  AlbumDetail.swift
//  Jewel
//
//  Created by Greg Hepworth on 30/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct ObservedAlbumDetail: View {
  
  @EnvironmentObject var store: AppStore
  
  private var slot: Slot? {
    if let i = store.state.collection.selectedSlot {
      return store.state.collection.slots[i]
    }
    return nil
  }
  
  var body: some View {
    IfLet(slot) { slot in
      AlbumView(slot: slot)
    }
    .onDisappear {
      self.store.update(action: CollectionAction.deselectSlot)
    }
  }
}
