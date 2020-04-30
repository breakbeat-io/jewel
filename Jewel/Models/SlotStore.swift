//
//  Wallet.swift
//  Jewel
//
//  Created by Greg Hepworth on 20/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import Foundation
import HMV

class SlotStore: ObservableObject {

    @Published var slots = [Slot]()
    private var userDefaults = UserDefaults.standard
    private var store: HMV?
    
    fileprivate func openStore() throws {
        let appleMusicApiToken = Bundle.main.infoDictionary?["APPLE_MUSIC_API_TOKEN"] as! String
        if appleMusicApiToken == "" {
            print("No Apple Music API Token Found!")
            throw JewelError.noAppleMusicApiToken
        } else {
            store = HMV(storefront: .unitedKingdom, developerToken: appleMusicApiToken)
        }
    }
    
    init() {
        
        //basically if we can't open the store we're dead in the water so for now may as well crash!
        try! openStore()
        
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
        store!.album(id: albumId, completion: {
            (album: Album?, error: Error?) -> Void in
            DispatchQueue.main.async {
                if album != nil {
                    let newSlot = Slot(id: slotId, album: album)
                    self.slots[slotId] = newSlot
                    self.saveWallet()
                }
            }
        })
    }
    
    func deleteAlbumFromSlot(slotId: Int) {
        let emptySlot = Slot(id: slotId)
        self.slots[slotId] = emptySlot
        self.saveWallet()
    }
    
    func loadRecommendations() {
        let request = URLRequest(url: URL(string: "https://breakbeat.io/jewel/recommendations.json")!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([String].self, from: data) {
                    // we have good data – go back to the main thread
                    for (index, albumId) in decodedResponse.enumerated() {
                        self.addAlbumToSlot(albumId: albumId, slotId: index)
                    }

                    // everything is good, so we can exit
                    return
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}
