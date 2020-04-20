//
//  DataSource.swift
//  Jewel
//
//  Created by Greg Hepworth on 16/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import HMV

var releasesData = load()
let store = HMV()

func load() -> [Release] {
    
    var releaseUrls = [String]()
    
    releaseUrls.append("https://music.apple.com/gb/album/all-that-must-be/1322664114")
    releaseUrls.append("https://music.apple.com/gb/album/based-on-a-true-story/1241281467")
    releaseUrls.append("https://music.apple.com/gb/album/the-fat-of-the-land/1450123945")
    releaseUrls.append("https://music.apple.com/gb/album/journey-inwards/595779873")
    releaseUrls.append("https://music.apple.com/gb/album/exit-planet-dust/723670972")
    releaseUrls.append("https://music.apple.com/gb/album/ok-computer/1097861387")
    releaseUrls.append("https://music.apple.com/gb/album/psyence-fiction/1440922148")
    releaseUrls.append("https://music.apple.com/gb/album/sincere-deluxe/1440230518")
    
    var releasesData = [Release]()
    
    for url in releaseUrls {
        do {
            releasesData.append(try store.getReleaseWith(shareUrl: url))
        } catch {
            print("There was an error loading the fake data: \(error).")
        }
    }
    
    return releasesData
}
