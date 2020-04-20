//
//  Wallet.swift
//  Jewel
//
//  Created by Greg Hepworth on 20/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import Foundation
import HMV

class Wallet: ObservableObject {
    @Published var releases = [Release]()
    
    init() {
        var releaseUrls = [String]()
        
        releaseUrls.append("https://music.apple.com/gb/album/all-that-must-be/1322664114")
        releaseUrls.append("https://music.apple.com/gb/album/based-on-a-true-story/1241281467")
        releaseUrls.append("https://music.apple.com/gb/album/the-fat-of-the-land/1450123945")
        releaseUrls.append("https://music.apple.com/gb/album/journey-inwards/595779873")
        releaseUrls.append("https://music.apple.com/gb/album/exit-planet-dust/723670972")
        releaseUrls.append("https://music.apple.com/gb/album/ok-computer/1097861387")
        releaseUrls.append("https://music.apple.com/gb/album/psyence-fiction/1440922148")
        releaseUrls.append("https://music.apple.com/gb/album/sincere-deluxe/1440230518")
        
        let store = HMV()
        
        for url in releaseUrls {
            do {
                releases.append(try store.getReleaseWith(shareUrl: url))
            } catch {
                print("There was an error loading the fake data: \(error).")
            }
        }
    }
}
