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
  print("Performing action: \(action)")
  
  var newAppState = appState
  
  switch action {
    
  case is OptionsAction:
    newAppState.options = updateOptions(options: newAppState.options, action: action as! OptionsAction)
    
  case is CollectionAction:
    newAppState.collection = updateCollection(collection: newAppState.collection, action: action as! CollectionAction)
    
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
    
  }
  
  return newOptions
}


func updateCollection(collection: Collection, action: CollectionAction) -> Collection {
  var newCollection = collection
  
  switch action {
    
  case .toggleActive:
    newCollection.active.toggle()
    
  case .setActiveState(activeState: let activeState):
    newCollection.active = activeState
    
  case .changeCollectionName(name: let name):
    newCollection.name = name
    
  case .changeCollectionCurator(curator: let curator):
    newCollection.curator = curator
    
  case .addAlbumToSlot(album: let album, slotIndex: let slotIndex):
    newCollection.slots[slotIndex].album = album
    
  case .removeAlbumFromSlot(slotIndexes: let slotIndexes):
    for i in slotIndexes {
      newCollection.slots[i] = Slot()
    }
    
  case .moveSlot(from: let from, to: let to):
    newCollection.slots.move(fromOffsets: from, toOffset: to)
    
  case .setPlatformLinks(baseUrl: let baseUrl, platformLinks: let platformLinks):
    let indices = newCollection.slots.enumerated().compactMap({ $1.album?.attributes?.url == baseUrl ? $0 : nil })
    for i in indices {
      newCollection.slots[i].playbackLinks = platformLinks
    }
    
  case .invalidateShareLinks:
    newCollection.shareLinkLong = nil
    newCollection.shareLinkShort = nil
    
  case .setShareLinks(shareLinkLong: let shareLinkLong, shareLinkShort: let shareLinkShort):
    newCollection.shareLinkLong = shareLinkLong
    newCollection.shareLinkShort = shareLinkShort
    
  case .setShareLinkError(errorState: let errorState):
    newCollection.shareLinkError = errorState
  }
  
  return newCollection
}

func updateLibrary(library: Library, action: LibraryAction) -> Library {
  var newLibrary = library
  
  switch action {
    
  case .addCollection(collection: let collection):
    newLibrary.collections.append(collection)
    
  case .removeCollection(slotIndexes: let slotIndexes):
    newLibrary.collections.remove(atOffsets: slotIndexes)
    
  case .moveCollection(from: let from, to: let to):
    newLibrary.collections.move(fromOffsets: from, toOffset: to)
    
  case .cueRecievedCollection(collection: let collection):
    newLibrary.recievedCollection = collection

  case .uncueRecievedCollection:
    newLibrary.recievedCollection = nil
    
  case .commitRecievedCollection:
    if let recievedCollection = newLibrary.recievedCollection {
      newLibrary.collections.append(recievedCollection)
    }
    newLibrary.recievedCollection = nil
    
  }
  
  return newLibrary
}

func updateSearch(search: Search, action: SearchAction) -> Search {
  var newSearch = search
  
  switch action {
    
  case .populateSearchResults(results: let results):
    newSearch.results = results
    
  case .removeSearchResults:
    newSearch.results = nil
    
  }
  
  return newSearch
}
