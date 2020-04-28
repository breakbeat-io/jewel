//
//  TrackList.swift
//  Jewel
//
//  Created by Greg Hepworth on 24/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct TrackList: View {
    
    @EnvironmentObject var wallet: WalletViewModel
    var slotId: Int
    
    var body: some View {
        TrackListItem(slotId: slotId)
    }
}

struct TrackList_Previews: PreviewProvider {
    static var previews: some View {
        TrackList(slotId: 0)
    }
}
