//
//  Wallet.swift
//  Jewel
//
//  Created by Greg Hepworth on 20/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import Foundation
import Cider

class Wallet: ObservableObject {
    @Published var releases = [Release]()
    
    init() {}
    
    func loadExampleWallet() {
        if let developerToken = Bundle.main.infoDictionary?["APPLE_MUSIC_API_TOKEN"] as? String {
            
            let cider = CiderClient(storefront: .unitedKingdom, developerToken: developerToken)
            
            releases.removeAll()
            
            let releases = ["1322664114", "1241281467", "1450123945", "595779873", "723670972", "1097861387", "1440922148", "1440230518"]
            
            for release in releases {
                cider.album(id: release, completion: {
                    (album: Album?, error: Error?) -> Void in
                    DispatchQueue.main.async {
                        let attributes = album?.attributes
                        
                        let release = Release(id: album!.id, appleMusicShareURL: attributes!.url, title: attributes!.name, artist: attributes!.artistName, artworkURL: (attributes?.artwork.url(forWidth: 1000))!)
                        
                        self.add(release: release)
                    }
                })
            }
        } else {
            print("No Apple Music API Token Found!")
        }
        
        
    }
    
    fileprivate func add(release: Release) {
        releases.append(release)
    }
    
}
