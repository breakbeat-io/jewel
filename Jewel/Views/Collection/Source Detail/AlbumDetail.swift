//
//  AlbumDetail.swift
//  Jewel
//
//  Created by Greg Hepworth on 30/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct AlbumDetail: View {
  
  @EnvironmentObject var store: AppStore
  
  var body: some View {
    ScrollView {
      VStack {
        AlbumCover()
        PlaybackLinks()
          .padding(.bottom)
        TrackList()
      }
      .padding()
    }
    .onDisappear {
      self.store.update(action: CollectionAction.deselectSlot)
    }
  }
}
