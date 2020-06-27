//
//  SearchProvider+Screenshots.swift
//  Jewel
//
//  Created by Greg Hepworth on 09/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

extension RecordStore {
  
  static func loadScreenshotCollection() {
    let albums = getScreenshotAlbums()
    for slotIndex in 0..<albums!.data!.count {
      AppEnvironment.global.update(action: LibraryAction.addSourceToSlot(source: albums!.data![slotIndex],
                                                                         slotIndex: slotIndex,
                                                                         collectionId: AppEnvironment.global.state.library.onRotation.id))
    }
  }

  static func exampleSearch() {
    let albums = getScreenshotAlbums()
    AppEnvironment.global.update(action: SearchAction.populateSearchResults(results: (albums?.data!)!))
  }
  
  static private func getScreenshotAlbums() -> ResponseRoot<Album>? {
    if let url = Bundle.main.url(forResource: "screenshotAlbums", withExtension: "json") {
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
