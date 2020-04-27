//
//  Wallet.swift
//  Jewel
//
//  Created by Greg Hepworth on 20/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import Foundation
import HMV

class WalletStore: ObservableObject {

    @Published var slots = [Slot]()
    private var userDefaults = UserDefaults.standard
    
    init() {
        
        //create an empty wallet
        let numberOfSlots = 8
        for slotId in 0..<numberOfSlots {
            let slot = Slot(id: slotId, album: nil)
            slots.append(slot)
        }
        
        //load it with any saved albums
        if let savedWallet = userDefaults.dictionary(forKey: "savedWallet") {
            for slotId in 0..<numberOfSlots {
                if let albumId = savedWallet[String(slotId)] {
                    addAlbumToSlot(albumId: albumId as! String, slotId: slotId)
                }
            }
        } else {
            print("No wallet saved! Starting fresh")
        }
    }
    
    func saveWallet() {
        var savedWallet = [String: String]()
        for (index, slot) in slots.enumerated() {
            if let album = slot.album {
                savedWallet[String(index)] = album.id
            }
        }
        userDefaults.set(savedWallet, forKey: "savedWallet")
    }
    
    func addAlbumToSlot(albumId: String, slotId: Int) {
        if let developerToken = Bundle.main.infoDictionary?["APPLE_MUSIC_API_TOKEN"] as? String {

            let hmv = HMV(storefront: .unitedKingdom, developerToken: developerToken)

            hmv.album(id: albumId, completion: {
                (album: Album?, error: Error?) -> Void in
                DispatchQueue.main.async {
                    if album != nil {
                        let newSlot = Slot(id: slotId, album: album)
                        self.slots[slotId] = newSlot
                        self.saveWallet()
                    }
                }
            })
        } else {
            print("No Apple Music API Token Found!")
        }
    }
    
    func deleteAlbumFromSlot(slotId: Int) {
        let emptySlot = Slot(id: slotId)
        self.slots[slotId] = emptySlot
        self.saveWallet()
    }

    func loadExampleWallet() {
        if let developerToken = Bundle.main.infoDictionary?["APPLE_MUSIC_API_TOKEN"] as? String {
            
            let hmv = HMV(storefront: .unitedKingdom, developerToken: developerToken)
            
            let exampleAlbums = ["1322664114", "1241281467", "1450123945", "595779873", "723670972", "1097861387", "1440922148", "1440230518"]
            
            for (index, album) in exampleAlbums.enumerated() {
                hmv.album(id: album, completion: {
                    (album: Album?, error: Error?) -> Void in
                    DispatchQueue.main.async {
                        if album != nil {
                            let slot = Slot(id: index, album: album!)
                            self.slots[index] = slot
                            self.saveWallet()
                        }
                    }
                })
            }
        } else {
            print("No Apple Music API Token Found!")
        }
    }
}
