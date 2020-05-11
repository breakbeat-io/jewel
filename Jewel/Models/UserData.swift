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

    @Published var prefs = JewelPreferences() {
        didSet {
            saveUserData(key: "jewelPreferences")
        }
    }
    @Published var collection = [Slot]() {
        didSet {
            saveUserData(key: "jewelCollection")
        }
    }
    
    private var userDefaults = UserDefaults.standard
    private var store: HMV?
    
    init() {
    
        // basically if we can't open the store we're dead in the water so for now may as well crash!
        try! openStore()
        
        loadUserData()
        
    }
    
    fileprivate func openStore() throws {
        
        let appleMusicApiToken = Bundle.main.infoDictionary?["APPLE_MUSIC_API_TOKEN"] as! String
        if appleMusicApiToken == "" {
            print("No Apple Music API Token Found!")
            throw JewelError.noAppleMusicApiToken
        } else {
            store = HMV(storefront: .unitedKingdom, developerToken: appleMusicApiToken)
        }
    }
    
    fileprivate func loadUserData() {
        
        // load saved user preferences
        if let savedPreferences = userDefaults.object(forKey: "jewelPreferences") as? Data {
            print("Loading user preferences")
            let decoder = JSONDecoder()
            if let decodedPreferences = try? decoder.decode(JewelPreferences.self, from: savedPreferences) {
                prefs = decodedPreferences
            }
        }
        
        // load saved user collection
        if let savedCollection = userDefaults.object(forKey: "jewelCollection") as? Data {
            print("Loading saved collection")
            let decoder = JSONDecoder()
            if let decodedCollection = try? decoder.decode([Slot].self, from: savedCollection) {
                collection = decodedCollection
            }
        }
        
        // if collection is empty, then initialise with empty slots
        if collection.count == 0 {
            print("No saved collection found, creating empty one")
            
            for slotId in 0..<prefs.numberOfSlots {
                let slot = Slot(id: slotId, album: nil)
                collection.append(slot)
            }
        }
    }
    
    fileprivate func saveUserData(key: String) {
        
        let encoder = JSONEncoder()
        
        switch key {
        case "jewelPreferences":
            if let encoded = try? encoder.encode(prefs) {
                userDefaults.set(encoded, forKey: key)
                print("Saved: \(key)")
            }
        case "jewelCollection":
            if let encoded = try? encoder.encode(collection) {
                userDefaults.set(encoded, forKey: key)
                print("Saved: \(key)")
            }
        default:
            print("Saving User Data: key unknown, nothing saved.")
        }
    }
    
    func addAlbumToSlot(albumId: String, slotId: Int) {
        store!.album(id: albumId, completion: {
            (album: Album?, error: Error?) -> Void in
            DispatchQueue.main.async {
                if album != nil {
                    let newSlot = Slot(id: slotId, album: album)
                    self.collection[slotId] = newSlot
                }
            }
        })
    }
    
    func deleteAlbumFromSlot(slotId: Int) {
        let emptySlot = Slot(id: slotId)
        self.collection[slotId] = emptySlot
    }
    
    func deleteAll() {
        for slotId in 0..<collection.count {
            deleteAlbumFromSlot(slotId: slotId)
        }
    }
    
    func reset() {
        let domain = Bundle.main.bundleIdentifier!
        userDefaults.removePersistentDomain(forName: domain)
        userDefaults.synchronize()
        exit(1)
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
