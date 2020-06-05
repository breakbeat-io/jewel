//
//  LibraryAlbumDetail.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct LibraryAlbumDetail: View {
  
  var slot: Slot
  
  var body: some View {
    ScrollView {
      VStack {
        IfLet(slot.album?.attributes) { attributes in
          LibraryAlbumCover(attributes: attributes)
          LibraryPlaybackLinks(slot: self.slot)
            .padding(.bottom)
          LibraryTrackList(slot: self.slot)
        }
      }
      .padding()
    }
  }
}
