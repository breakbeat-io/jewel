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
  
  @EnvironmentObject var app: AppEnvironment
  
  let slotId: Int
  let collectionId: UUID
  
  private var slot: Slot? {
    if collectionId == app.state.library.onRotation.id {
      return app.state.library.onRotation.slots[slotId]
    } else {
      if let collectionIndex = app.state.library.collections.firstIndex(where: { $0.id == collectionId }) {
        return app.state.library.collections[collectionIndex].slots[slotId]
      }
    }
    
    return nil
  }
  
  var body: some View {
    IfLet(slot) { slot in
      AlbumDetail(slot: slot)
    }
  }
}
