//
//  SearchProvider+Screenshots.swift
//  Jewel
//
//  Created by Greg Hepworth on 09/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import os.log
import MusicKit

extension RecordStore {
  
//  static func loadScreenshotCollection() {
//    let albums = getScreenshotData(forView: "Collection")
//    for slotIndex in 0..<albums!.data!.count {
//      AppEnvironment.global.update(action: LibraryAction.addSourceToSlot(source: albums!.data![slotIndex],
//                                                                         slotIndex: slotIndex,
//                                                                         collectionId: AppEnvironment.global.state.library.onRotation.id))
//    }
//  }
//
//  static func exampleSearch() {
//    let albums = getScreenshotData(forView: "Search")
//    AppEnvironment.global.update(action: SearchAction.populateSearchResults(results: (albums?.data!)!))
//  }
//  
//  static private func getScreenshotData(forView: String) -> ResponseRoot<Album>? {
//    if let url = Bundle.main.url(forResource: "screenshot" + forView, withExtension: "json") {
//      do {
//        let data = try Data(contentsOf: url)
//        let decoder = JSONDecoder()
//        let album = try decoder.decode(ResponseRoot<Album>.self, from: data)
//        return album
//      } catch {
//        os_log("💎 Screenshot Generator > Error: %s", error.localizedDescription)
//      }
//    }
//    return nil
//  }
}
