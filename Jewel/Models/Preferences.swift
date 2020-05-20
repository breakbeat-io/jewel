//
//  JewelPreferences.swift
//  Jewel
//
//  Created by Greg Hepworth on 11/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct Preferences: Codable {
    
    static let saveKey = "jewelPreferences"
    var preferredMusicPlatform = 0 {
        didSet {
            save()
        }
    }
    var debugMode = false {
        didSet {
            save()
        }
    }
    
    init() {
        if let savedPreferences = UserDefaults.standard.object(forKey: Self.saveKey) as? Data {
            do {
                let decodedPreferences = try JSONDecoder().decode(Preferences.self, from: savedPreferences)
                self = decodedPreferences
                print("Loaded user preferences")
                return
            } catch {
                print(error)
            }
        }
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
