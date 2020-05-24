//
//  Collection.swift
//  Jewel
//
//  Created by Greg Hepworth on 13/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

class Collection: ObservableObject, Codable {
    
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
    var shareLinkLong: URL?
    @Published var shareLinkShort: URL?
    
    enum CodingKeys: CodingKey {
        case name
        case curator
        case slots
        case editable
    }
    
    static let user = Collection(name: "My Collection", curator: "A Music Lover", editable: true, saveKey: "jewelCollection")
    static let shared = Collection(name: "Their Collection", curator: "A Music Lover", editable: false, saveKey: "jewelSharedCollection")
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        curator = try container.decode(String.self, forKey: .curator)
        slots = try container.decode([Slot].self, forKey: .slots)
        editable = try container.decode(Bool.self, forKey: .editable)
    }
    
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
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(curator, forKey: .curator)
        try container.encode(slots, forKey: .slots)
        try container.encode(editable, forKey: .editable)
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
    
    func generateShareLinks() {
        if shareLinkLong == nil {
            print("no links found, generating")
            shareLinkLong = generateLongLink()
            generateShortLink()
        } else {
            let newLongLink = generateLongLink()
            if newLongLink == shareLinkLong {
                print("Long link hasn't changed, reusing short link")
            } else {
                print("Long link changed, regenerating links")
                shareLinkShort = nil
                shareLinkLong = generateLongLink()
                generateShortLink()
            }
        }
    }
    
    private func generateLongLink() -> URL {
        
        var shareableSlots = [ShareableSlot?]()
        
        for slot in slots {
            if let content = slot.source?.content {
                let slot = ShareableSlot(sourceProvider: slot.source!.provider, sourceRef: content.id)
                shareableSlots.append(slot)
            } else {
                shareableSlots.append(nil)
            }
        }
        
        let shareableCollection = ShareableCollection(
            collectionName: name == "My Collection" ? "\(curator)'s Collection" : name,
            collectionCurator: curator,
            collection: shareableSlots
        )
        
        let encoder = JSONEncoder()
        let shareableCollectionJson = try! encoder.encode(shareableCollection)
        
        return URL(string: "https://jewel.breakbeat.io/share/?c=\(shareableCollectionJson.base64EncodedString())")!
        
    }
    
    private func generateShortLink() {
        
        let firebasePrefix = "https://jewelshare.page.link"
        
        let longDynamicLink = firebasePrefix + "/?link=" + shareLinkLong!.absoluteString
        
        let firebaseShortLinkBody = ["longDynamicLink": longDynamicLink]
        
        let uploadData = try! JSONEncoder().encode(firebaseShortLinkBody)
        
        let url = URL(string: "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=***REMOVED***")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.uploadTask(with: request, from: uploadData) { data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            guard let response = response as? HTTPURLResponse,
                (200...299).contains(response.statusCode) else {
                    print ("server error")
                    return
            }
            if let mimeType = response.mimeType,
                mimeType == "application/json",
                let data = data {
                do {
                    // make sure this JSON is in the format we expect
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            // try to read out a string array
                            print(json["shortLink"] as! String)
                            //                        if let firebaseShortLink =  {
                            self.shareLinkShort = URL(string: json["shortLink"] as! String)!
                            print(self.shareLinkShort)
                            //                        }
                        }
                    }
                } catch let error as NSError {
                    print("Failed to load: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
        
    }
    
}
