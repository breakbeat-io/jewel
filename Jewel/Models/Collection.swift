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
    var name: String
    var curator: String
    var slots = [Slot](repeating: Slot(), count: 8)
    var editable: Bool
    
    static let user = Collection(name: "My Collection", curator: "A Music Lover", editable: true, saveKey: "jewelCollection")
    static let shared = Collection(name: "Their Collection", curator: "A Music Lover", editable: false, saveKey: "jewelSharedCollection")
    
    init(name: String, curator: String, editable: Bool) {
        self.name = name
        self.curator = curator
        self.editable = editable
    }
    
    init(name: String, curator: String, editable: Bool, saveKey: String) {
        
        if let savedCollection = UserDefaults.standard.object(forKey: saveKey) as? Data {
            print("Loading collection: \(saveKey)")
            if let decodedCollection = try? JSONDecoder().decode(Collection.self, from: savedCollection) {
                self.saveKey = saveKey
                self.name = decodedCollection.name
                self.curator = decodedCollection.curator
                self.slots = decodedCollection.slots
                self.editable = decodedCollection.editable
                return
            }
        }
        
        self.name = name
        self.curator = curator
        self.editable = editable
        self.saveKey = saveKey
    }
    
    func save() {
        if saveKey != nil {
            if let encoded = try? JSONEncoder().encode(self) {
                UserDefaults.standard.set(encoded, forKey: saveKey!)
                print("Saved collection: \(saveKey!)")
            }
        }
    }
    
}
