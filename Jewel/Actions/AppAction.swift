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
  print(action.description)
  
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
    
  case let .userCollectionActive(userCollectionActive):
    newLibrary.userCollectionActive = userCollectionActive
    
  case let .setUserCollectionName(name):
    newLibrary.userCollection.name = name
    
  case let .setUserCollectionCurator(curator):
    newLibrary.userCollection.curator = curator
    
  case let .removeAlbumFromSlot(slotIndexes):
    for i in slotIndexes {
      newLibrary.userCollection.slots[i] = Slot()
    }
    
  case let .moveSlot(from, to):
    newLibrary.userCollection.slots.move(fromOffsets: from, toOffset: to)
    
  case .invalidateShareLinks:
    newLibrary.userCollection.shareLinkLong = nil
    newLibrary.userCollection.shareLinkShort = nil
    
  case let .setShareLinks(shareLinkLong, shareLinkShort):
    newLibrary.userCollection.shareLinkLong = shareLinkLong
    newLibrary.userCollection.shareLinkShort = shareLinkShort
    
  case let .shareLinkError(errorState):
    newLibrary.userCollection.shareLinkError = errorState
    
  case let .addSharedCollection(collection):
    newLibrary.sharedCollections.insert(collection, at: 0)
    
  case let .removeSharedCollection(slotIndexes):
    newLibrary.sharedCollections.remove(atOffsets: slotIndexes)
    
  case let .moveSharedCollection(from, to):
    newLibrary.sharedCollections.move(fromOffsets: from, toOffset: to)
    
  case let .cueSharedCollection(shareableCollection):
    newLibrary.cuedCollection = shareableCollection
    
  case .uncueSharedCollection:
    newLibrary.cuedCollection = nil
    
  case let .addAlbumToSlot(album, slotIndex, collectionId):
    if newLibrary.userCollection.id == collectionId {
      newLibrary.userCollection.slots[slotIndex].album = album
    } else {
      if let collectionIndex = newLibrary.sharedCollections.firstIndex(where: { $0.id == collectionId }) {
        newLibrary.sharedCollections[collectionIndex].slots[slotIndex].album = album
      }
    }
    
  case let .setPlatformLinks(baseUrl, platformLinks, collectionId):
    if newLibrary.userCollection.id == collectionId {
      let indices = newLibrary.userCollection.slots.enumerated().compactMap({ $1.album?.attributes?.url == baseUrl ? $0 : nil })
      for i in indices {
        newLibrary.userCollection.slots[i].playbackLinks = platformLinks
      }
    } else {
      if let collectionIndex = newLibrary.sharedCollections.firstIndex(where: { $0.id == collectionId }) {
        let indices = newLibrary.sharedCollections[collectionIndex].slots.enumerated().compactMap({ $1.album?.attributes?.url == baseUrl ? $0 : nil })
        for i in indices {
          newLibrary.sharedCollections[collectionIndex].slots[i].playbackLinks = platformLinks
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
