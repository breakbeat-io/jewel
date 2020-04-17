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
    var releasesData = [Release]()
    
    releasesData.append(store.getRelease(appleMusicShareURL: "https://music.apple.com/gb/album/all-that-must-be/1322664114"))
    releasesData.append(store.getRelease(appleMusicShareURL: "https://music.apple.com/gb/album/based-on-a-true-story/1241281467"))
    releasesData.append(store.getRelease(appleMusicShareURL: "https://music.apple.com/gb/album/the-fat-of-the-land/1450123945"))
    releasesData.append(store.getRelease(appleMusicShareURL: "https://music.apple.com/gb/album/journey-inwards/595779873"))
    releasesData.append(store.getRelease(appleMusicShareURL: "https://music.apple.com/gb/album/exit-planet-dust/723670972"))
    releasesData.append(store.getRelease(appleMusicShareURL: "https://music.apple.com/gb/album/ok-computer/1097861387"))
    releasesData.append(store.getRelease(appleMusicShareURL: "https://music.apple.com/gb/album/psyence-fiction/1440922148"))
    releasesData.append(store.getRelease(appleMusicShareURL: "https://music.apple.com/gb/album/sincere-deluxe/1440230518"))
    
    return releasesData
}
