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

    @Published var albums = [Album]()

    func loadExampleWallet() {
        if let developerToken = Bundle.main.infoDictionary?["APPLE_MUSIC_API_TOKEN"] as? String {
            
            let hmv = HMV(storefront: .unitedKingdom, developerToken: developerToken)
            
            albums.removeAll()
            
            let exampleAlbums = ["1322664114", "1241281467", "1450123945", "595779873", "723670972", "1097861387", "1440922148", "1440230518"]
            
            for album in exampleAlbums {
                hmv.album(id: album, completion: {
                    (album: Album?, error: Error?) -> Void in
                    DispatchQueue.main.async {
                        if album != nil {
                            self.albums.append(album!)
                        }
                    }
                })
            }
        } else {
            print("No Apple Music API Token Found!")
        }
    }
}
