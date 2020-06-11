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
  
  private var slot: Slot {
      environment.state.library.userCollection.slots[slotId]
  }
  
  var body: some View {
    AlbumDetail(slot: slot)
  }
}
