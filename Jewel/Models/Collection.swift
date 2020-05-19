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
    var curator = "A Music Lover"
    var slots = [Slot](repeating: Slot(), count: 8)
    var editable: Bool
    
    static let user = Collection(name: "My Collection", editable: true, saveKey: "jewelCollection")
    static let shared = Collection(name: "Their Collection", editable: false, saveKey: "jewelSharedCollection")
    
    init(name: String, editable: Bool) {
        self.name = name
        self.editable = editable
    }
    
    init(name: String, editable: Bool, saveKey: String) {
        
        if let savedCollection = UserDefaults.standard.object(forKey: saveKey) as? Data {
            print("Loading collection: \(saveKey)")
            if let decodedCollection = try? JSONDecoder().decode(Collection.self, from: savedCollection) {
                self.name = decodedCollection.name
                self.curator = decodedCollection.curator
                self.slots = decodedCollection.slots
                self.editable = decodedCollection.editable
                return
            }
        }
        
        self.name = name
        self.editable = editable
        self.saveKey = saveKey
    }
}
