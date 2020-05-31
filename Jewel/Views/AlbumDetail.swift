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
    
    var body: some View {
        ScrollView {
            AlbumCover(album: album)
            IfLet(album.attributes?.url) { url in
                PlaybackLink(url: url)
                    .padding(.bottom)
            }
            TrackList(album: album)
        }
        .padding()
    }
}
