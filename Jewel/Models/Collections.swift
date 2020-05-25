//
//  Collections.swift
//  Jewel
//
//  Created by Greg Hepworth on 20/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import Foundation
import Combine
import HMV

class Collections: ObservableObject {
    
    @Published var userCollection = Collection.user
    @Published var sharedCollection = Collection.shared
    
    @Published var activeCollection: Collection! = nil  // force to nil, is replaced in init. feels bad.
    
    @Published var userCollectionActive = true {
        didSet {
            if userCollectionActive {
                print("Switching to User Collection")
                activeCollection = userCollection
            } else {
                print("Switching to Shared Collection")
                activeCollection = sharedCollection
            }
        }
    }
    
    @Published var candidateCollection: Collection?
    @Published var sharedCollectionCued = false
    
    var anyCancellableUser: AnyCancellable? = nil
    var anyCancellableShared: AnyCancellable? = nil
    
    init() {
        
        migrateV1UserDefaults()
        activeCollection = userCollection
        
        anyCancellableUser = userCollection.objectWillChange.sink { (_) in
            self.objectWillChange.send()
        }
        anyCancellableShared = sharedCollection.objectWillChange.sink { (_) in
            self.objectWillChange.send()
        }
        
    }
    
    fileprivate func migrateV1UserDefaults() {
        
        if let v1CollectionName = UserDefaults.standard.string(forKey: "collectionName") {
            print("v1.0 Collection Name found ... migrating.")
            userCollection.name = v1CollectionName
            UserDefaults.standard.removeObject(forKey: "collectionName")
        }
        
        if let savedCollection = UserDefaults.standard.dictionary(forKey: "savedCollection") {
            print("v1.0 Saved Collection found ... migrating.")
            for slotIndex in 0..<userCollection.slots.count {
                if let albumId = savedCollection[String(slotIndex)] {
                    addContentToSlot(contentId: albumId as! String, collection: userCollection, slotIndex: slotIndex)
                }
            }
            UserDefaults.standard.removeObject(forKey: "savedCollection")
        }
        
    }
    
    func addContentToSlot(contentId: String, collection: Collection, slotIndex: Int) {
        Store.appleMusic.album(id: contentId, completion: {
            (album: Album?, error: Error?) -> Void in
            DispatchQueue.main.async {
                if album != nil {
                    let source = Source(contentId: album!.id, content: album!)
                    let newSlot = Slot(source: source)
                    collection.slots[slotIndex] = newSlot
                    if let baseUrl = album?.attributes?.url {
                        self.populatePlatformLinks(baseUrl: baseUrl, slotIndex: slotIndex)
                    }
                    self.objectWillChange.send()
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
                        self.objectWillChange.send()
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
        self.objectWillChange.send()
    }
    
    func ejectUserCollection() {
        userCollectionActive = true
        for slotIndex in 0..<activeCollection.slots.count {
            ejectSourceFromSlot(slotIndex: slotIndex)
        }
    }
    
    func ejectSharedCollection() {
        sharedCollection = Collection(name: "Their Collection", curator: "A Music Lover", editable: false)
        self.objectWillChange.send()
        userCollectionActive = true
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
        
        candidateCollection = Collection.shared
        candidateCollection?.name = recievedCollection.collectionName
        candidateCollection?.curator = recievedCollection.collectionCurator
        
        for (index, slot) in recievedCollection.collection.enumerated() {
            if slot?.sourceProvider == SourceProvider.appleMusicAlbum {
                addContentToSlot(contentId: slot!.sourceRef, collection: candidateCollection!, slotIndex: index)
            }
        }
        
        userCollectionActive = false
        
    }
    
    func loadCandidateCollection() {
        if candidateCollection != nil {
            sharedCollection = candidateCollection!
            candidateCollection = nil
            userCollectionActive = false
            self.objectWillChange.send()
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
