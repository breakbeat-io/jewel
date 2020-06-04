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
    newAppState.options = updateOptions(optionsState: newAppState.options, action: action as! OptionsAction)
    
  case is CollectionAction:
    newAppState.collection = updateCollection(collectionState: newAppState.collection, action: action as! CollectionAction)
    
  case is LibraryAction:
    newAppState.library = updateLibrary(libraryState: newAppState.library, action: action as! LibraryAction)
    
  case is SearchAction:
    newAppState.search = updateSearch(searchState: newAppState.search, action: action as! SearchAction)
    
  default: break
    
  }
  
  return newAppState
}

func updateOptions(optionsState: OptionsState, action: OptionsAction) -> OptionsState {
  var newOptionsState = optionsState
  
  switch action {
    
  case .setPreferredPlatform(platform: let platform):
    newOptionsState.preferredMusicPlatform = platform
    
  case .toggleDebugMode:
    newOptionsState.debugMode.toggle()
    
  case .reset:
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
    exit(1)
    
  }
  
  return newOptionsState
}


func updateCollection(collectionState: CollectionState, action: CollectionAction) -> CollectionState {
  var newCollectionState = collectionState
  
  switch action {
    
  case .toggleActive:
    newCollectionState.active.toggle()
    
  case .changeCollectionName(name: let name):
    newCollectionState.name = name
    
  case .changeCollectionCurator(curator: let curator):
    newCollectionState.curator = curator
    
  case .setSelectedSlot(slotIndex: let slotIndex):
    newCollectionState.selectedSlot = slotIndex
    
  case .deselectSlot:
    newCollectionState.selectedSlot = nil
    
  case .addAlbumToSlot(album: let album, slotIndex: let slotIndex):
    newCollectionState.slots[slotIndex].album = album
    
  case .removeAlbumFromSlot(slotIndexes: let slotIndexes):
    for i in slotIndexes {
      newCollectionState.slots[i] = Slot()
    }
    
  case .moveSlot(from: let from, to: let to):
    newCollectionState.slots.move(fromOffsets: from, toOffset: to)
    
  case .setPlatformLinks(baseUrl: let baseUrl, platformLinks: let platformLinks):
    let indices = newCollectionState.slots.enumerated().compactMap({ $1.album?.attributes?.url == baseUrl ? $0 : nil })
    for i in indices {
      newCollectionState.slots[i].playbackLinks = platformLinks
    }
  }
  
  return newCollectionState
}

func updateLibrary(libraryState: LibraryState, action: LibraryAction) -> LibraryState {
  var newLibraryState = libraryState
  
  switch action {
    
  case .addCollection(collection: let collection):
    newLibraryState.collections.append(collection)
    
  case .removeCollection(slotIndexes: let slotIndexes):
    newLibraryState.collections.remove(atOffsets: slotIndexes)
    
  case .moveCollection(from: let from, to: let to):
    newLibraryState.collections.move(fromOffsets: from, toOffset: to)
    
  }
  
  return newLibraryState
}

func updateSearch(searchState: SearchState, action: SearchAction) -> SearchState {
  var newSearchState = searchState
  
  switch action {
    
  case .populateSearchResults(results: let results):
    newSearchState.results = results
    
  case .removeSearchResults:
    newSearchState.results = nil
    
  }
  
  return newSearchState
}
