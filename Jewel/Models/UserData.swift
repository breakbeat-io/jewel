//
//  UserData.swift
//  Jewel
//
//  Created by Greg Hepworth on 20/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import Foundation
import HMV

class UserData: ObservableObject {

    @Published var prefs = JewelPreferences()
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
        
        //create an empty collection
        for slotId in 0..<prefs.numberOfSlots {
            let slot = Slot(id: slotId, album: nil)
            slots.append(slot)
        }
        
        loadUserData()
        
    }
    
    func loadUserData() {
        
        prefs.collectionName = userDefaults.string(forKey: "collectionName") ?? "My Collection"
        
        if let savedCollection = userDefaults.dictionary(forKey: "savedCollection") {
            for slotId in 0..<slots.count {
                if let albumId = savedCollection[String(slotId)] {
                    addAlbumToSlot(albumId: albumId as! String, slotId: slotId)
                }
            }
        } else {
            print("No collection saved! Starting fresh")
        }
        
//        if let savedUserData = userDefaults.
        
    }
    
    func saveUserData() {
        
        userDefaults.set(prefs.collectionName, forKey: "collectionName")
        
        var savedCollection = [String: String]()
        for (index, slot) in slots.enumerated() {
            if let album = slot.album {
                savedCollection[String(index)] = album.id
            }
        }
        userDefaults.set(savedCollection, forKey: "savedCollection")

    }
    
    func addAlbumToSlot(albumId: String, slotId: Int) {
        store!.album(id: albumId, completion: {
            (album: Album?, error: Error?) -> Void in
            DispatchQueue.main.async {
                if album != nil {
                    let newSlot = Slot(id: slotId, album: album)
                    self.slots[slotId] = newSlot
                    self.saveUserData()
                }
            }
        })
    }
    
    func deleteAlbumFromSlot(slotId: Int) {
        let emptySlot = Slot(id: slotId)
        self.slots[slotId] = emptySlot
        self.saveUserData()
    }
    
    func deleteAll() {
        for slotId in 0..<slots.count {
            deleteAlbumFromSlot(slotId: slotId)
        }
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
