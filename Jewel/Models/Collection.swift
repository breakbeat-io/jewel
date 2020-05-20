//
//  Collection.swift
//  Jewel
//
//  Created by Greg Hepworth on 13/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

class Collection: Codable {
    
    private var saveKey: String?
    private var numberOfSlots = 8
    
    var name: String {
        didSet {
            save()
        }
    }
    var curator: String {
        didSet {
            save()
        }
    }
    var slots = [Slot]() {
        didSet {
            save()
        }
    }
    let editable: Bool
    
    static let user = Collection(name: "My Collection", curator: "A Music Lover", editable: true, saveKey: "jewelCollection")
    static let shared = Collection(name: "Their Collection", curator: "A Music Lover", editable: false, saveKey: "jewelSharedCollection")
    
    init(name: String, curator: String, editable: Bool) {
        self.name = name
        self.curator = curator
        self.editable = editable
        
        initialiseSlots()
    }
    
    init(name: String, curator: String, editable: Bool, saveKey: String) {
        
        if let savedCollection = UserDefaults.standard.object(forKey: saveKey) as? Data {
            do {
                let decodedCollection = try JSONDecoder().decode(Collection.self, from: savedCollection)
                self.saveKey = saveKey
                self.name = decodedCollection.name
                self.curator = decodedCollection.curator
                self.slots = decodedCollection.slots
                self.editable = decodedCollection.editable
                print("Loaded collection: \(saveKey)")
                return
            } catch {
                print(error)
            }
        }
        
        self.name = name
        self.curator = curator
        self.editable = editable
        self.saveKey = saveKey
        
        initialiseSlots()
    }
    
    private func initialiseSlots() {
        for _ in 0..<numberOfSlots {
            let slot = Slot()
            slots.append(slot)
        }
    }
    
    private func save() {
        if saveKey != nil {
            do {
                let encoded = try JSONEncoder().encode(self)
                UserDefaults.standard.set(encoded, forKey: saveKey!)
                print("Saved collection: \(saveKey!)")
            } catch {
                print(error)
            }
        }
    }
    
}
