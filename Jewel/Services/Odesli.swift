//
//  Odesli.swift
//  Listen Later
//
//  Created by Greg Hepworth on 02/06/2020.
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

struct OdesliLink: Codable, Hashable {
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
  case audius
  case bandcamp
}

enum OdesliPlatform: String, Codable, CaseIterable {
  case appleMusic
  case itunes
  case spotify
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
  case audius
  case bandcamp
  
  var friendlyName: String {
    switch self {
    case .appleMusic:
      return "Apple Music"
    case .itunes:
      return "iTunes"
    case .spotify:
      return "Spotify"
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
    case .audius:
      return "Audius"
    case .bandcamp:
      return "Bandcamp"
    }
  }
  
  var iconRef: String? {
    switch self {
    case .appleMusic:
      return "\u{f179}"
    case .itunes:
      return "\u{f179}"
    case .spotify:
      return "\u{f1bc}"
    case .youtube:
      return "\u{f167}"
    case .youtubeMusic:
      return "\u{f167}"
    case .google:
      return "\u{f1a0}"
    case .googleStore:
      return "\u{f3ab}"
    case .pandora:
      return nil
    case .deezer:
      return "\u{e077}"
    case .tidal:
      return nil
    case .amazonStore:
      return "\u{f270}"
    case .amazonMusic:
      return "\u{f270}"
    case .soundcloud:
      return "\u{f1be}"
    case .napster:
      return "\u{f3d2}"
    case .yandex:
      return "\u{f413}"
    case .spinrilla:
      return nil
    case .audius:
      return nil
    case .bandcamp:
      return "\u{f2d5}"
    }
  }
  
}

