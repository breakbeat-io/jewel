//
//  Slot.swift
//  Listen Later
//
//  Created by Greg Hepworth on 02/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

struct Slot: Identifiable, Codable {
    var id = UUID()
    var album: Album?
//        didSet {
//            print("Album is \(album?.attributes?.artistName)")
//            print("Slot is \(store.state.collection.selectedSlot)")
//            print("Slot Id is \(store.state.collection.slots[store.state.collection.selectedSlot!].id)")
//            store.update(action: CollectionAction.fetchAndSetPlatformLinks)
//            print("Album is \(album?.attributes?.artistName)")
//        }
//    }
    var playbackLinks: OdesliResponse?
}
