//
//  SearchProvider+Screenshots.swift
//  Jewel
//
//  Created by Greg Hepworth on 09/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

extension SearchProvider {
    
    func exampleSearch() {
        let albums = getScreenshotAlbums()
        results = albums?.data
    }
    
    func getScreenshotAlbums() -> ResponseRoot<Album>? {
        if let url = Bundle.main.url(forResource: "screenshotSearchAlbums", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let album = try decoder.decode(ResponseRoot<Album>.self, from: data)
                return album
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
