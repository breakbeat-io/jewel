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
  print("💎 Update >  \(action.description)")
  
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
    
  case let .setPreferredPlatform(platform):
    newOptions.preferredMusicPlatform = platform
    
  case .toggleDebugMode:
    newOptions.debugMode.toggle()
    
  case .reset:
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
    exit(1)
    
  case let .firstTimeRun(firstTimeRunState):
    newOptions.firstTimeRun = firstTimeRunState
  }
  
  return newOptions
}

func updateLibrary(library: Library, action: LibraryAction) -> Library {
  
  var newLibrary = library
  
  switch action {
    
  case let .setCollectionName(name, collectionId):
    if collectionId == newLibrary.onRotation.id {
      newLibrary.onRotation.name = name
    } else if let collectionIndex = newLibrary.collections.firstIndex(where: { $0.id == collectionId }) {
      newLibrary.collections[collectionIndex].name = name
    }
    
  case let .setCollectionCurator(curator, collectionId):
    if collectionId == newLibrary.onRotation.id {
      newLibrary.onRotation.curator = curator
    } else if let collectionIndex = newLibrary.collections.firstIndex(where: { $0.id == collectionId }) {
      newLibrary.collections[collectionIndex].curator = curator
    }
    
  case let .addAlbumToSlot(album, slotIndex, collectionId):
    if collectionId == newLibrary.onRotation.id {
      newLibrary.onRotation.slots[slotIndex].album = album
    } else if let collectionIndex = newLibrary.collections.firstIndex(where: { $0.id == collectionId }) {
      newLibrary.collections[collectionIndex].slots[slotIndex].album = album
    }
    
  case let .removeAlbumFromSlot(slotIndexes, collectionId):
    if collectionId == newLibrary.onRotation.id {
      for i in slotIndexes {
        newLibrary.onRotation.slots[i] = Slot()
      }
    } else if let collectionIndex = newLibrary.collections.firstIndex(where: { $0.id == collectionId }) {
      for i in slotIndexes {
        newLibrary.collections[collectionIndex].slots[i] = Slot()
      }
    }
    
  case let .moveSlot(from, to, collectionId):
    if collectionId == newLibrary.onRotation.id {
      newLibrary.onRotation.slots.move(fromOffsets: from, toOffset: to)
    } else if let collectionIndex = newLibrary.collections.firstIndex(where: { $0.id == collectionId }) {
      newLibrary.collections[collectionIndex].slots.move(fromOffsets: from, toOffset: to)
    }
    
  case let .invalidateShareLinks(collectionId):
    if collectionId == newLibrary.onRotation.id {
      newLibrary.onRotation.shareLinkLong = nil
      newLibrary.onRotation.shareLinkShort = nil
    } else if let collectionIndex = newLibrary.collections.firstIndex(where: { $0.id == collectionId }) {
      newLibrary.collections[collectionIndex].shareLinkLong = nil
      newLibrary.collections[collectionIndex].shareLinkShort = nil
    }
    
  case let .setShareLinks(shareLinkLong, shareLinkShort, collectionId):
    if collectionId == newLibrary.onRotation.id {
      newLibrary.onRotation.shareLinkLong = shareLinkLong
      newLibrary.onRotation.shareLinkShort = shareLinkShort
    } else if let collectionIndex = newLibrary.collections.firstIndex(where: { $0.id == collectionId }) {
      newLibrary.collections[collectionIndex].shareLinkLong = shareLinkLong
      newLibrary.collections[collectionIndex].shareLinkShort = shareLinkShort
    }
    
  case let .shareLinkError(errorState, collectionId):
    if collectionId == newLibrary.onRotation.id {
      newLibrary.onRotation.shareLinkError = errorState
    } else if let collectionIndex = newLibrary.collections.firstIndex(where: { $0.id == collectionId }) {
      newLibrary.collections[collectionIndex].shareLinkError = errorState
    }
    
  case let .saveOnRotation(collection):
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM yyyy"
    let dateString = formatter.string(from: Date())
    var newCollection = collection
    newCollection.id = UUID()
    newCollection.name = "On Rotation — \(dateString)"
    newLibrary.collections.insert(newCollection, at: 0)
    
  case .addUserCollection:
    let newCollection = Collection(type: .userCollection, name: "New Collection", curator: "A Music Lover")
    newLibrary.collections.insert(newCollection, at: 0)
    
  case let .addSharedCollection(collection):
    newLibrary.collections.insert(collection, at: 0)
    
  case let .removeSharedCollection(slotIndexes):
    newLibrary.collections.remove(atOffsets: slotIndexes)
    
  case let .moveSharedCollection(from, to):
    newLibrary.collections.move(fromOffsets: from, toOffset: to)
    
  case let .cueSharedCollection(shareableCollection):
    newLibrary.cuedCollection = shareableCollection
    
  case .uncueSharedCollection:
    newLibrary.cuedCollection = nil
    
  case let .setPlatformLinks(baseUrl, platformLinks, collectionId):
    if newLibrary.onRotation.id == collectionId {
      let indices = newLibrary.onRotation.slots.enumerated().compactMap({ $1.album?.attributes?.url == baseUrl ? $0 : nil })
      for i in indices {
        newLibrary.onRotation.slots[i].playbackLinks = platformLinks
      }
    } else if let collectionIndex = newLibrary.collections.firstIndex(where: { $0.id == collectionId }) {
      let indices = newLibrary.collections[collectionIndex].slots.enumerated().compactMap({ $1.album?.attributes?.url == baseUrl ? $0 : nil })
      for i in indices {
        newLibrary.collections[collectionIndex].slots[i].playbackLinks = platformLinks
      }
    }
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
