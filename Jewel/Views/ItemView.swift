//
//  ItemView.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct ItemView: View {
    
    let album: JewelAlbum
    
    var body: some View {
        HStack {
            Text(album.title)
            Spacer()
            Text(album.artist)
        }
        .padding()
    }
}

//struct ItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        ItemView()
//    }
//}
