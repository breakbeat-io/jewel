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
    let linksByPlatform: [String: OdesliLink]
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

enum OdesliApiProvider: String, Codable, CaseIterable {
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

enum OdesliPlatform: String, Codable, CaseIterable {
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
    
    var friendlyName: String {
        switch self {
        case .spotify:
            return "Spotify"
        case .itunes:
            return "iTunes"
        case .appleMusic:
            return "Apple Music"
        case .youtube:
            return "YouTube"
        case .youtubeMusic:
            return "YouTube Music"
        case .google:
            return "Google"
        case .googleStore:
            return "Google Store"
        case .pandora:
            return "Pandora"
        case .deezer:
            return "Deezer"
        case .tidal:
            return "TIDAL"
        case .amazonStore:
            return "Amazon"
        case .amazonMusic:
            return "Amazon Music"
        case .soundcloud:
            return "SoundCloud"
        case .napster:
            return "Napster"
        case .yandex:
            return "Yandex"
        case .spinrilla:
            return "Spinrilla"
        }
    }
}
