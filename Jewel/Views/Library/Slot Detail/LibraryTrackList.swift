//
//  LibraryTrackList.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct LibraryTrackList: View {
  
  var slot: Slot
  
  private var discCount: Int? {
    slot.album?.relationships?.tracks.data?.map { $0.attributes?.discNumber ?? 1 }.max()
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      IfLet(discCount) { discCount in
        ForEach(1..<discCount + 1, id: \.self) { discNumber in
          DiscTrackList(
            discNumber: discNumber,
            tracks: (self.slot.album?.relationships?.tracks.data?.filter { $0.attributes?.discNumber == discNumber })!,
            showDiscNumber: (discCount > 1) ? true : false,
            albumArtist: (self.slot.album?.attributes?.artistName)!)
        }
      }
    }
  }
}
