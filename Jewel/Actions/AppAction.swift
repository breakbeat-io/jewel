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
  //  print("Performing action: \(action)")
  
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
    
  case .setPreferredPlatform(platform: let platform):
    newOptions.preferredMusicPlatform = platform
    
  case .toggleDebugMode:
    newOptions.debugMode.toggle()
    
  case .reset:
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
    exit(1)
    
  case .firstTimeRun(_: let firstTimeRunState):
    newOptions.firstTimeRun = firstTimeRunState
  }
  
  return newOptions
}

func updateLibrary(library: Library, action: LibraryAction) -> Library {
  var newLibrary = library
  
  switch action {
    
  case .userCollectionActive(let userCollectionActive):
    newLibrary.userCollectionActive = userCollectionActive
    
  case .changeUserCollectionName(let name):
    newLibrary.userCollection.name = name
    
  case .changeUserCollectionCurator(let curator):
    newLibrary.userCollection.curator = curator
    
  case .removeAlbumFromSlot(let slotIndexes):
    for i in slotIndexes {
      newLibrary.userCollection.slots[i] = Slot()
    }
    
  case .moveSlot(let from, let to):
    newLibrary.userCollection.slots.move(fromOffsets: from, toOffset: to)
    
  case .invalidateShareLinks:
    newLibrary.userCollection.shareLinkLong = nil
    newLibrary.userCollection.shareLinkShort = nil
    
  case .setShareLinks(let shareLinkLong, let shareLinkShort):
    newLibrary.userCollection.shareLinkLong = shareLinkLong
    newLibrary.userCollection.shareLinkShort = shareLinkShort
    
  case .shareLinkError(let errorState):
    newLibrary.userCollection.shareLinkError = errorState
    
  case .addSharedCollection(let collection):
    newLibrary.sharedCollections.insert(collection, at: 0)
    
  case .removeSharedCollection(let slotIndexes):
    newLibrary.sharedCollections.remove(atOffsets: slotIndexes)
    
  case .moveSharedCollection(let from, let to):
    newLibrary.sharedCollections.move(fromOffsets: from, toOffset: to)
    
  case .cueSharedCollection(let shareableCollection):
    newLibrary.cuedCollection = shareableCollection
    
  case .uncueSharedCollection:
    newLibrary.cuedCollection = nil
    
  case .addAlbumToSlot(let album, let slotIndex, let collectionId):
    if newLibrary.userCollection.id == collectionId {
      newLibrary.userCollection.slots[slotIndex].album = album
    } else {
      if let collectionIndex = newLibrary.sharedCollections.firstIndex(where: { $0.id == collectionId }) {
        newLibrary.sharedCollections[collectionIndex].slots[slotIndex].album = album
      }
    }
    
  case .setPlatformLinks(let baseUrl, let platformLinks, let collectionId):
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
    
  case .populateSearchResults(let results):
    newSearch.results = results
    
  case .removeSearchResults:
    newSearch.results = nil
    
  }
  
  return newSearch
}
