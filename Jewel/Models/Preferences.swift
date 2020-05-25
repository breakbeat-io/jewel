//
//  JewelPreferences.swift
//  Jewel
//
//  Created by Greg Hepworth on 11/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

class Preferences: ObservableObject, Codable {
    
    static let saveKey = "jewelPreferences"
    @Published var preferredMusicPlatform = 0 {
        didSet {
            save()
        }
    }
    @Published var debugMode = false {
        didSet {
            save()
        }
    }
    @Published var firstTimeRun = true {
        didSet {
            save()
        }
    }
    
    enum CodingKeys: CodingKey {
        case preferredMusicPlatform
        case debugMode
        case firstTimeRun
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        preferredMusicPlatform = try container.decode(Int.self, forKey: .preferredMusicPlatform)
        debugMode = try container.decode(Bool.self, forKey: .debugMode)
        firstTimeRun = try container.decode(Bool.self, forKey: .firstTimeRun)
    }
    
    init() {
        if let savedPreferences = UserDefaults.standard.object(forKey: Self.saveKey) as? Data {
            do {
                let decodedPreferences = try JSONDecoder().decode(Preferences.self, from: savedPreferences)
                self.preferredMusicPlatform = decodedPreferences.preferredMusicPlatform
                self.debugMode = decodedPreferences.debugMode
                self.firstTimeRun = decodedPreferences.firstTimeRun
                print("Loaded user preferences")
                return
            } catch {
                print(error)
            }
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(preferredMusicPlatform, forKey: .preferredMusicPlatform)
        try container.encode(debugMode, forKey: .debugMode)
        try container.encode(firstTimeRun, forKey: .firstTimeRun)
    }
    
    func reset() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        exit(1)
    }
    
    private func save() {
        do {
            let encoded = try JSONEncoder().encode(self)
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
            print("Saved user preferences")
        } catch {
            print(error)
        }
    }
    
}
