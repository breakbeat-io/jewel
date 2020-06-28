//
//  DiscTrackList.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct DiscTrackList: View {
  
  let discNumber: Int
  let discTracks: [Track]
  let showDiscNumber: Bool
  let sourceArtist: String
  
  var body: some View {
    VStack(alignment: .leading) {
      if showDiscNumber {
        Text("Disc \(discNumber)")
          .fontWeight(.bold)
          .padding(.vertical)
      }
      ForEach(discTracks) { track in
        IfLet(track.attributes) { attributes in
          HStack {
            Text(String(attributes.trackNumber))
              .font(.footnote)
              .frame(width: 20, alignment: .center)
              .padding(.vertical)
              .padding(.trailing)
            VStack(alignment: .leading) {
              Text(attributes.name)
                .font(.callout)
                .fontWeight(.medium)
                .lineLimit(1)
              if attributes.artistName != self.sourceArtist {
                Text(attributes.artistName)
                  .font(.callout)
                  .fontWeight(.light)
                  .opacity(0.7)
                  .lineLimit(1)
              }
            }
            Spacer()
            IfLet(attributes.duration) { duration in
              Text(duration)
                .font(.footnote)
                .opacity(0.7)
            }
          }
        }
      }
    }
  }
}
