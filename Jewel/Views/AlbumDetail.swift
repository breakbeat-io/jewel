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
    
    let album: Album
    
    private var playbackLinks: OdesliResponse? {
        let slot = store.state.collection.slots.first(where: { $0.album?.id == album.id })!
        return slot.playbackLinks
    }
    
    var body: some View {
        ScrollView {
            AlbumCover(album: album)
            IfLet(album.attributes?.url) { url in
                PlaybackLinks(url: url, playbackLinks: self.playbackLinks)
                    .padding(.bottom)
            }
            TrackList(album: album)
        }
        .padding()
    }
}
