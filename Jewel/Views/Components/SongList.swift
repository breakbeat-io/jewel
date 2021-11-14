//
//  TrackList.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import MusicKit

struct SongList: View {
  
  let songs: [Song]
  let albumArtistName: String

  private var discCount: Int? {
    songs.map { $0.discNumber ?? 1 }.max()
  }

  var body: some View {
    VStack(alignment: .leading) {
      if let discCount = discCount {
        ForEach(1..<discCount + 1, id: \.self) { discNumber in
          DiscSongList(
            discNumber: discNumber,
            discSongs: songs.filter { $0.discNumber == discNumber },
            showDiscNumber: (discCount > 1) ? true : false,
            albumArtistName: albumArtistName
          )
        }
      }
    }
  }
}
