//
//  Action.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

func updateState(appState: AppState, action: AppAction) -> AppState {
  print("💎 Update > \(action.description)")
  
  var newAppState = appState
  
  switch action {
    
  case is OptionsAction:
    newAppState.options = updateOptions(options: newAppState.options, action: action as! OptionsAction)
    
  case is LibraryAction:
    newAppState.library = updateLibrary(library: newAppState.library, action: action as! LibraryAction)
    
  case is SearchAction:
    newAppState.search = updateSearch(search: newAppState.search, action: action as! SearchAction)
    
  default: break
    
  }
  
  return newAppState
}

func updateOptions(options: Options, action: OptionsAction) -> Options {
  
  var newOptions = options
  
  switch action {
    
  case let .firstTimeRun(firstTimeRunState):
    newOptions.firstTimeRun = firstTimeRunState
    
  case let .setDefaultCurator(curator):
    newOptions.defaultCurator = curator
    
  case let .setPreferredPlatform(platform):
    newOptions.preferredMusicPlatform = platform
    
  case .reset:
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
    exit(1)
    
  }
  
  return newOptions
}

func updateLibrary(library: Library, action: LibraryAction) -> Library {
  
  func extractCollection(collectionId: UUID) -> Collection? {
    if newLibrary.onRotation.id == collectionId {
      return newLibrary.onRotation
    } else if let collectionIndex = newLibrary.collections.firstIndex(where: { $0.id == collectionId }) {
      return newLibrary.collections[collectionIndex]
    }
    return nil
  }
  
  func commitCollection(collection: Collection) {
    if collection.id == newLibrary.onRotation.id {
      newLibrary.onRotation = collection
    } else if let collectionIndex = newLibrary.collections.firstIndex(where: { $0.id == collection.id }) {
      newLibrary.collections[collectionIndex] = collection
    }
  }
  
  var newLibrary = library
  
  switch action {
    
  case let .setCollectionName(name, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      collection.name = name
      commitCollection(collection: collection)
    }
    
  case let .setCollectionCurator(curator, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      collection.curator = curator
      commitCollection(collection: collection)
    }
    
  case let .addSourceToSlot(source, slotIndex, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      collection.slots[slotIndex].source = source
      commitCollection(collection: collection)
    }
    
  case let .removeSourceFromSlot(slotIndexes, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      for i in slotIndexes {
        collection.slots[i] = Slot()
      }
      commitCollection(collection: collection)
    }
    
  case let .removeSourcesFromCollection(sourceIds, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      for sourceId in sourceIds {
        collection.slots[sourceId] = Slot()
      }
      commitCollection(collection: collection)
    }
    
  case let .moveSlot(from, to, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      collection.slots.move(fromOffsets: from, toOffset: to)
      commitCollection(collection: collection)
    }
    
  case let .invalidateShareLinks(collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      collection.shareLinkLong = nil
      collection.shareLinkShort = nil
      commitCollection(collection: collection)
    }
    
  case let .setShareLinks(shareLinkLong, shareLinkShort, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      collection.shareLinkLong = shareLinkLong
      collection.shareLinkShort = shareLinkShort
      commitCollection(collection: collection)
    }
    
  case let .saveOnRotation(collection):
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM yyyy"
    let dateString = formatter.string(from: Date())
    var newCollection = collection
    newCollection.id = UUID()
    newCollection.name = "My On Rotation — \(dateString)"
    newLibrary.collections.insert(newCollection, at: 0)
    
  case .addUserCollection:
    let newCollection = Collection(type: .userCollection, name: "New Collection", curator: AppEnvironment.global.state.options.defaultCurator)
    newLibrary.collections.insert(newCollection, at: 0)
    
  case let .addSharedCollection(collection):
    newLibrary.collections.insert(collection, at: 0)
    
  case let .removeSharedCollection(slotIndexes):
    newLibrary.collections.remove(atOffsets: slotIndexes)
    
  case let .removeSharedCollections(collectionIds):
    for collectionId in collectionIds {
      newLibrary.collections.removeAll(where: { $0.id == collectionId} )
    }
    
  case let .moveSharedCollection(from, to):
    newLibrary.collections.move(fromOffsets: from, toOffset: to)
    
  case let .cueSharedCollection(shareableCollection):
    newLibrary.cuedCollection = shareableCollection
    
  case .uncueSharedCollection:
    newLibrary.cuedCollection = nil
    
  case let .setPlatformLinks(baseUrl, platformLinks, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      let indices = collection.slots.enumerated().compactMap({ $1.source?.attributes?.url == baseUrl ? $0 : nil })
      for i in indices {
        collection.slots[i].playbackLinks = platformLinks
      }
      commitCollection(collection: collection)
    }
    
  }
  
  return newLibrary
  
}

func updateSearch(search: Search, action: SearchAction) -> Search {
  
  var newSearch = search
  
  switch action {
    
  case let .populateSearchResults(results):
    newSearch.results = results
    
  case .removeSearchResults:
    newSearch.results = nil
    
  }
  
  return newSearch
}
