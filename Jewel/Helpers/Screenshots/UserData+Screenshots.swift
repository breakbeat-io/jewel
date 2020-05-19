//
//  HMV+Screenshots.swift
//  Jewel
//
//  Created by Greg Hepworth on 09/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

extension UserData {
    
    func loadScreenshotCollection() {
        let albums = getScreenshotAlbums()
        for slotIndex in 0..<albums!.data!.count {
            let source = Source(contentId: albums!.data![slotIndex].id, content: albums!.data![slotIndex])
            let newSlot = Slot(source: source)
            self.activeCollection.slots[slotIndex] = newSlot
        }
    }
    
    func getScreenshotAlbums() -> ResponseRoot<Album>? {
        if let url = Bundle.main.url(forResource: "screenshotCollectionAlbums", withExtension: "json") {
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
