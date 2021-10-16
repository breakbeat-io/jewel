//
//  TrackList.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import MusicKit

struct TrackList: View {
  
  let tracks: MusicItemCollection<Track>
  let sourceArtist: String

//  private var discCount: Int? {
//    tracks.map { $0.discNumber ?? 1 }.max()
//  }

  var body: some View {
    VStack(alignment: .leading) {
//      IfLet(discCount) { discCount in
//        ForEach(1..<discCount + 1, id: \.self) { discNumber in
//          DiscTrackList(
//            discNumber: discNumber,
//            discTracks: self.tracks.filter { $0.discNumber == discNumber },
//            showDiscNumber: (discCount > 1) ? true : false,
//            sourceArtist: self.sourceArtist
//          )
//        }
//      }
    }
  }
}
