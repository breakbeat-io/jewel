//
//  NewFilledSlot.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct NewFilledSlot: View {
  
  @EnvironmentObject var store: AppStore
  
  let attributes: AlbumAttributes
  var slotIndex: Int?
  
  var body: some View {
    Button(action: {
      if let slotIndex = self.slotIndex {
        self.store.update(action: CollectionAction.setSelectedSlot(slotIndex: slotIndex))
      }
    }) {
      IfLet(attributes) { attributes in
        AlbumCard(albumName: attributes.name,
                  albumArtist: attributes.artistName,
                  albumArtwork: attributes.artwork.url(forWidth: 1000))
      }
    }
  }
}
