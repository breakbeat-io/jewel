//
//  DiscTrackList.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import MusicKit

struct DiscSongList: View {
  
  let discNumber: Int
  let discSongs: [Song]
  let showDiscNumber: Bool
  let sourceArtist: String
  
  var body: some View {
    VStack(alignment: .leading) {
      if showDiscNumber {
        Text("Disc \(discNumber)")
          .fontWeight(.bold)
          .padding(.vertical)
      }
      ForEach(discSongs) { song in
        HStack {
          Text(String(song.trackNumber ?? 0))
            .font(.footnote)
            .frame(width: 20, alignment: .center)
            .padding(.vertical)
            .padding(.trailing)
          VStack(alignment: .leading) {
            Text(song.title)
              .font(.callout)
              .fontWeight(.medium)
              .lineLimit(1)
            if song.artistName != self.sourceArtist {
              Text(song.artistName)
                .font(.callout)
                .fontWeight(.light)
                .opacity(0.7)
                .lineLimit(1)
            }
          }
          Spacer()
          IfLet(song.durationString) { duration in
            Text(duration)
              .font(.footnote)
              .opacity(0.7)
          }
        }
      }
    }
  }
}
