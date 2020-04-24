//
//  Wallet.swift
//  Jewel
//
//  Created by Greg Hepworth on 20/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import Foundation
import HMV

class Wallet: ObservableObject {

    @Published var slots = [Slot]()
    
    init() {
        let numberOfSlots = 8
        for slotId in 0...numberOfSlots - 1 {
            let slot = Slot(id: slotId, album: nil)
            slots.append(slot)
        }
    }

    func loadExampleWallet() {
        if let developerToken = Bundle.main.infoDictionary?["APPLE_MUSIC_API_TOKEN"] as? String {
            
            let hmv = HMV(storefront: .unitedKingdom, developerToken: developerToken)
            
            slots.removeAll()
            
            let exampleAlbums = ["1322664114", "1241281467", "1450123945", "595779873", "723670972", "1097861387", "1440922148", "1440230518"]
            
            for (index, album) in exampleAlbums.enumerated() {
                hmv.album(id: album, completion: {
                    (album: Album?, error: Error?) -> Void in
                    DispatchQueue.main.async {
                        if album != nil {
                            let slot = Slot(id: index, album: album!)
                            self.slots.append(slot)
                        }
                    }
                })
            }
        } else {
            print("No Apple Music API Token Found!")
        }
    }
    
    func addAlbumToSlot(albumId: String, slotId: Int) {
        print("Adding album to slot: \(albumId) to \(slotId)")
        
        if let developerToken = Bundle.main.infoDictionary?["APPLE_MUSIC_API_TOKEN"] as? String {

            let hmv = HMV(storefront: .unitedKingdom, developerToken: developerToken)

            hmv.album(id: albumId, completion: {
                (album: Album?, error: Error?) -> Void in
                DispatchQueue.main.async {
                    if album != nil {
                        let slot = Slot(id: slotId, album: album)
                        self.slots[slotId] = slot
                        print(slot.album?.attributes?.name)
                    }
                }
            })

        } else {
            print("No Apple Music API Token Found!")
        }
    }
}
