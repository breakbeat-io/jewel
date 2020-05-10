//
//  OdesliResponse.swift
//  Jewel
//
//  Created by Greg Hepworth on 10/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct OdesliResponse: Codable {
    let entityUniqueId: String
    let userCountry: String
    let pageUrl: URL
    let entitiesByUniqueId: [String: OdesliEntity]
    let linksByPlatform: RawKeyedCodableDictionary<OdesliPlatform, OdesliLink>
}

struct OdesliLink: Codable {
    let url: URL
    let nativeAppUriMobile: String?
    let nativeAppUriDesktop: String?
    let entityUniqueId: String
}

struct OdesliEntity: Codable {
    let id: String
    let type: String
    let title: String?
    let artistName: String?
    let thumbnailUrl: URL?
    let thumbnailWidth: Int?
    let thumbnailHeight: Int?
    let apiProvider: OdesliApiProvider
    let platforms: [OdesliPlatform]
}

enum OdesliApiProvider: String, Codable {
    case spotify
    case itunes
    case youtube
    case google
    case pandora
    case deezer
    case tidal
    case amazon
    case soundcloud
    case napster
    case yandex
    case spinrilla
}

enum OdesliPlatform: String, Codable {
    case spotify
    case itunes
    case appleMusic
    case youtube
    case youtubeMusic
    case google
    case googleStore
    case pandora
    case deezer
    case tidal
    case amazonStore
    case amazonMusic
    case soundcloud
    case napster
    case yandex
    case spinrilla
}

@propertyWrapper
struct RawKeyedCodableDictionary<Key, Value>: Codable where Key: Hashable & RawRepresentable, Key.RawValue: Codable & Hashable, Value: Codable {
    var wrappedValue: [Key: Value]

    init() {
        wrappedValue = [:]
    }

    init(wrappedValue: [Key: Value]) {
        self.wrappedValue = wrappedValue
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawKeyedDictionary = try container.decode([Key.RawValue: Value].self)

        wrappedValue = [:]
        for (rawKey, value) in rawKeyedDictionary {
            guard let key = Key(rawValue: rawKey) else {
                throw DecodingError.dataCorruptedError(
                    in: container, debugDescription: "Invalid key: cannot initalize \(Key.self) from invalid \(Key.RawValue.self) value \(rawKey)")
            }
            wrappedValue[key] = value
        }
    }

    func encode(to encoder: Encoder) throws {
        let rawKeyedDictionary = Dictionary(uniqueKeysWithValues: wrappedValue.map { ($0.rawValue, $1) })
        var container = encoder.singleValueContainer()
        try container.encode(rawKeyedDictionary)
    }
}
