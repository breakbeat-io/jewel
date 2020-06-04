//
//  AlbumTrackList.swift
//  Jewel
//
//  Created by Greg Hepworth on 30/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct TrackList: View {
  
  @EnvironmentObject var store: AppStore
  
  private var slot: Slot? {
    if let i = store.state.collection.selectedSlot {
      return store.state.collection.slots[i]
    }
    return nil
  }
  private var discCount: Int? {
    slot?.album?.relationships?.tracks.data?.map { $0.attributes?.discNumber ?? 1 }.max()
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      IfLet(discCount) { discCount in
        ForEach(1..<discCount + 1, id: \.self) {
          DiscTrackList(discNumber: $0, withTitle: (discCount > 1) ? true : false)
        }
      }
    }
  }
}
