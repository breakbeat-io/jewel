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
  
  @EnvironmentObject var environment: AppEnvironment
  
  let slotId: Int
  let collectionId: UUID
  
  private var slot: Slot? {
    if collectionId == environment.state.library.onRotation.id {
      return environment.state.library.onRotation.slots[slotId]
    } else {
      if let collectionIndex = environment.state.library.sharedCollections.firstIndex(where: { $0.id == collectionId }) {
        return environment.state.library.sharedCollections[collectionIndex].slots[slotId]
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
