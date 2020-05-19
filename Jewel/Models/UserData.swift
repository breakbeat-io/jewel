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
    
    @Published var prefs = Preferences()
    
    @Published var userCollection = Collection.user
    @Published var userCollectionActive = true {
        didSet {
            if userCollectionActive {
                print("Activating User Collection")
                activeCollection = userCollection
            } else {
                print("Activating Shared Collection")
                activeCollection = sharedCollection
            }
        }
    }
    @Published var sharedCollection = Collection.shared
    
    @Published var activeCollection = Collection(name: "My Collection", editable: true) // TODO: Make this optional so I don't haev to give it a crap one just to instantly get rid of it.
    
    @Published var candidateCollection: Collection?
    @Published var sharedCollectionCued = false
    
    private var userDefaults = UserDefaults.standard
    
    init() {

        migrateV1UserDefaults()
        
        activeCollection = userCollection
        
    }
    
    fileprivate func saveUserData(key: String) {
        
        let encoder = JSONEncoder()
        
        switch key {    
        case "jewelCollection":
            if let encoded = try? encoder.encode(userCollection) {
                userDefaults.set(encoded, forKey: key)
                print("Saved collection")
            }
        case "jewelSharedCollection":
            if let encoded = try? encoder.encode(sharedCollection) {
                userDefaults.set(encoded, forKey: key)
                print("Saved shared collection")
            }
        default:
            print("Saving User Data: key unknown, nothing saved.")
        }
    }
    
    func collectionChanged() {
        self.objectWillChange.send()
        // just save everything at the moment even if not active - the whole repetition of stuff needs to be changed anyway!
        self.saveUserData(key: "jewelCollection")
        self.saveUserData(key: "jewelSharedCollection")
    }
    
    func preferencesChanged() {
        self.objectWillChange.send()
    }
    
    fileprivate func migrateV1UserDefaults() {
        
        if let v1CollectionName = userDefaults.string(forKey: "collectionName") {
            print("v1.0 Collection Name found ... migrating.")
            userCollection.name = v1CollectionName
            userDefaults.removeObject(forKey: "collectionName")
            saveUserData(key: "jewelCollection")
        }
        
        if let savedCollection = userDefaults.dictionary(forKey: "savedCollection") {
            print("v1.0 Saved Collection found ... migrating.")
            for slotIndex in 0..<userCollection.slots.count {
                if let albumId = savedCollection[String(slotIndex)] {
                    addAlbumToSlot(albumId: albumId as! String, collection: userCollection, slotIndex: slotIndex)
                }
            }
            userDefaults.removeObject(forKey: "savedCollection")
            saveUserData(key: "jewelCollection")
        }
        
    }
    
    func addAlbumToSlot(albumId: String, collection: Collection, slotIndex: Int) {
        Store.appleMusic.album(id: albumId, completion: {
            (album: Album?, error: Error?) -> Void in
            DispatchQueue.main.async {
                if album != nil {
                    let source = Source(contentId: album!.id, content: album!)
                    let newSlot = Slot(source: source)
                    collection.slots[slotIndex] = newSlot
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
                        self.activeCollection.slots[slotIndex].playbackLinks = decodedResponse
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
    
    func ejectSourceFromSlot(slotIndex: Int) {
        let emptySlot = Slot()
        self.activeCollection.slots[slotIndex] = emptySlot
        self.collectionChanged()
    }
    
    func ejectUserCollection() {
        userCollectionActive = true
        for slotIndex in 0..<activeCollection.slots.count {
            ejectSourceFromSlot(slotIndex: slotIndex)
        }
    }
    
    func ejectSharedCollection() {
        sharedCollection = Collection(name: "Their Collection", editable: false)
        self.collectionChanged()
        userCollectionActive = true
    }
    
    func reset() {
        let domain = Bundle.main.bundleIdentifier!
        userDefaults.removePersistentDomain(forName: domain)
        userDefaults.synchronize()
        exit(1)
    }
    
    func createShareUrl() -> URL {
        
        var shareableSlots = [ShareableSlot?]()
        
        for slot in activeCollection.slots {
            if let content = slot.source?.content {
                let slot = ShareableSlot(sourceProvider: slot.source!.provider, sourceRef: content.id)
                shareableSlots.append(slot)
            } else {
                shareableSlots.append(nil)
            }
        }
        
        let shareableCollection = ShareableCollection(
            collectionName: activeCollection.name == "My Collection" ? "\(activeCollection.curator)'s Collection" : activeCollection.name,
            collectionCurator: activeCollection.curator,
            collection: shareableSlots
        )
        
        let encoder = JSONEncoder()
        let shareableCollectionJson = try! encoder.encode(shareableCollection)
        
        return URL(string: "https://jewel.breakbeat.io/share/?c=\(shareableCollectionJson.base64EncodedString())")!
        
    }
    
    func processRecievedCollection(recievedCollectionUrl: URL) {
        if let urlComponents = URLComponents(url: recievedCollectionUrl, resolvingAgainstBaseURL: true) {
            let params = urlComponents.queryItems
            if let recievedCollectionEncoded = Data(base64Encoded: (params!.first(where: { $0.name == "c" })?.value!)!) {
                let decoder = JSONDecoder()
                if let recievedCollection = try? decoder.decode(ShareableCollection.self, from: recievedCollectionEncoded) {
                    cueCandidateCollection(recievedCollection: recievedCollection)
                    sharedCollectionCued = true
                }
            }
        }
    }
    
    func cueCandidateCollection(recievedCollection: ShareableCollection) {
        
        candidateCollection = Collection(name: recievedCollection.collectionName, editable: false)
        candidateCollection!.curator = recievedCollection.collectionCurator
        
        for (index, slot) in recievedCollection.collection.enumerated() {
            if slot?.sourceProvider == SourceProvider.appleMusicAlbum {
                addAlbumToSlot(albumId: slot!.sourceRef, collection: candidateCollection!, slotIndex: index)
            }
        }
        
        userCollectionActive = false
        
    }
    
    func loadCandidateCollection() {
        if candidateCollection != nil {
            sharedCollection = candidateCollection!
            candidateCollection = nil
            userCollectionActive = false
            collectionChanged()
        }
    }
    
    func getRecommendations() {
        
        let request = URLRequest(url: URL(string: "https://jewel.breakbeat.io/recommendations.json")!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(ShareableCollection.self, from: data) {
                    DispatchQueue.main.async {
                        self.cueCandidateCollection(recievedCollection: decodedResponse)
                        self.loadCandidateCollection()
                        return
                    }
                }
            }
            
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}
