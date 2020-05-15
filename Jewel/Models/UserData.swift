//
//  UserData.swift
//  Jewel
//
//  Created by Greg Hepworth on 20/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

// TODO
// * How can I not initialise activeCollection seeing as it just points to somethign else.


import Foundation
import HMV

class UserData: ObservableObject {

    @Published var prefs = Preferences.default
    @Published var myCollection = Collection(name: "My Collection", editable: true)
    @Published var activeCollection = Collection(name: "My Collection", editable: true) // TODO: Make this optional so I don't haev to give it a crap one just to instantly get rid of it.
    
    private var userDefaults = UserDefaults.standard
    private var store: HMV?
    
    init() {
    
        // basically if we can't open the store we're dead in the water so for now may as well crash!
        try! openStore()
        
        migrateV1UserDefaults()
        loadUserData()
        
        activeCollection = myCollection
        
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
            if let decodedPreferences = try? decoder.decode(Preferences.self, from: savedPreferences) {
                prefs = decodedPreferences
            }
        }
        
        // load saved user collection
        if let savedCollection = userDefaults.object(forKey: "jewelCollection") as? Data {
            print("Loading collection")
            let decoder = JSONDecoder()
            if let decodedCollection = try? decoder.decode(Collection.self, from: savedCollection) {
                myCollection = decodedCollection
            }
        }
    }
    
    fileprivate func saveUserData(key: String) {
        
        let encoder = JSONEncoder()
        
        switch key {
        case "jewelPreferences":
            if let encoded = try? encoder.encode(prefs) {
                userDefaults.set(encoded, forKey: key)
                print("Saved user preferences")
            }
        case "jewelCollection":
            if let encoded = try? encoder.encode(myCollection) {
                userDefaults.set(encoded, forKey: key)
                print("Saved collection")
            }
        default:
            print("Saving User Data: key unknown, nothing saved.")
        }
    }
    
    func collectionChanged() {
        self.objectWillChange.send()
        self.saveUserData(key: "jewelCollection")
    }
    
    func preferencesChanged() {
        self.objectWillChange.send()
        self.saveUserData(key: "jewelPreferences")
    }
    
    fileprivate func migrateV1UserDefaults() {
        
        if let v1CollectionName = userDefaults.string(forKey: "collectionName") {
            print("v1.0 Collection Name found ... migrating.")
            myCollection.name = v1CollectionName
            userDefaults.removeObject(forKey: "collectionName")
            saveUserData(key: "jewelCollection")
        }
        
        if let savedCollection = userDefaults.dictionary(forKey: "savedCollection") {
            print("v1.0 Saved Collection found ... migrating.")
            for slotIndex in 0..<myCollection.slots.count {
                let slot = Slot()
                myCollection.slots.append(slot)
                if let albumId = savedCollection[String(slotIndex)] {
                    addAlbumToSlot(albumId: albumId as! String, slotIndex: slotIndex)
                }
            }
            userDefaults.removeObject(forKey: "savedCollection")
            saveUserData(key: "jewelCollection")
        }

    }
    
    func addAlbumToSlot(albumId: String, slotIndex: Int) {
        store!.album(id: albumId, completion: {
            (album: Album?, error: Error?) -> Void in
            DispatchQueue.main.async {
                if album != nil {
                    let source = Source(sourceReference: album!.id, album: album)
                    let newSlot = Slot(source: source)
                    self.myCollection.slots[slotIndex] = newSlot
                    if let baseUrl = album?.attributes?.url {
                        self.populatePlatformLinks(baseUrl: baseUrl, slotIndex: slotIndex)
                    }
                    self.collectionChanged()
                }
            }
        })
    }
    
    func populatePlatformLinks(baseUrl: URL, slotIndex: Int) {
        print("populating links for \(baseUrl.absoluteString) in slot \(slotIndex)")
        
        let request = URLRequest(url: URL(string: "https://api.song.link/v1-alpha.1/links?url=\(baseUrl.absoluteString)")!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                if response.statusCode != 200 {
                    print(response.statusCode)
                }
            }
            
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(OdesliResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.myCollection.slots[slotIndex].playbackLinks = decodedResponse
                        self.collectionChanged()
                    }
                    
                    return
                }
            }
            
            if let error = error {
                print("Error getting playbackLinks: \(error.localizedDescription)")
            }
            
        }.resume()
    }
    
    func deleteAlbumFromSlot(slotIndex: Int) {
        let emptySlot = Slot()
        self.myCollection.slots[slotIndex] = emptySlot
        self.collectionChanged()
    }
    
    func deleteAll() {
        for slotIndex in 0..<myCollection.slots.count {
            deleteAlbumFromSlot(slotIndex: slotIndex)
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
                        self.addAlbumToSlot(albumId: albumId, slotIndex: index)
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
