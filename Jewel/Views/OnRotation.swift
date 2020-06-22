//
//  OnRotation.swift
//  Listen Later
//
//  Created by Greg Hepworth on 21/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct OnRotation: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var collection: Collection {
    app.state.library.onRotation
  }
  private var slots: [Slot] {
    collection.slots
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("On Rotation")
        .font(.title)
        .fontWeight(.bold)
      Text("by hepto")
        .font(.subheadline)
        .fontWeight(.light)
        .foregroundColor(.secondary)
      GeometryReader { geo in
        VStack {
          ForEach(self.slots.indices, id: \.self) { slotIndex in
            Group {
            if self.slots[slotIndex].album != nil {
              IfLet(self.slots[slotIndex].album?.attributes) { attributes in
                AlbumCard(albumName: attributes.name, albumArtist: attributes.artistName, albumArtwork: attributes.artwork.url(forWidth: 1000))
              }
            } else {
              RoundedRectangle(cornerRadius: 8)
                .foregroundColor(Color(UIColor.secondarySystemBackground))
                .frame(height: (geo.size.height / 8) - 5 )
              }
            }
          }
        }
      }
    }
    .padding()
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
  }
}
