//
//  FilledSlot.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct FilledSlot: View {
    
    var slot: Slot
    
    var body: some View {
        Unwrap(slot.album?.attributes) { albumAttributes in
            NavigationLink(
                destination: ReleaseDetail (
                    albumAttributes: albumAttributes
                )
            ) {
                ReleaseListItem (
                    albumAttributes: albumAttributes
                )
            }
        }
    }
}

struct FilledSlot_Previews: PreviewProvider {
    
    static let wallet = Wallet()
    
    static var previews: some View {
        FilledSlot(slot: wallet.slots[0])
    }
}
