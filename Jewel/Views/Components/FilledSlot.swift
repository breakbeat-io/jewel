//
//  NewFilledSlot.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct FilledSlot: View {
  
  @EnvironmentObject var store: AppStore
  
  let attributes: AlbumAttributes
  
  var body: some View {
    IfLet(attributes) { attributes in
      AlbumCard(albumName: attributes.name,
                albumArtist: attributes.artistName,
                albumArtwork: attributes.artwork.url(forWidth: 1000))
    }
  }
}
