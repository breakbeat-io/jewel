//
//  Action.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import HMV

func updateState(state: AppState, action: AppAction) -> AppState {
    var state = state
    
    switch action {
    case is OptionsAction:
        state.options = updateOptions(state: state.options, action: action as! OptionsAction)
    case is CollectionAction:
        state.collection = updateCollection(state: state.collection, action: action as! CollectionAction)
    case is SearchAction:
        state.search = updateSearch(state: state.search, action: action as! SearchAction)
    default: break
    }
    
    return state
}

func updateOptions(state: OptionsState, action: OptionsAction) -> OptionsState {
    var state = state
    
    switch action {
    case .setPreferredPlatform(platform: let platform):
        state.preferredMusicPlatform = platform
    }
    
    return state
}


func updateCollection(state: CollectionState, action: CollectionAction) -> CollectionState {
    var state = state
    
    switch action {
    case .changeCollectionName(name: let name):
        state.name = name
    case .changeCollectionCurator(curator: let curator):
        state.curator = curator
    case .setSelectedSlot(slotIndex: let slotIndex):
        state.selectedSlot = slotIndex
    case .fetchAndAddAlbum(albumId: let albumId):
        RecordStore.appleMusic.album(id: albumId, completion: {
            (album: Album?, error: Error?) -> Void in
            DispatchQueue.main.async {
                if album != nil {
                    store.update(action: CollectionAction.addAlbum(album: album!))
                }
            }
        })
    case .addAlbum(album: let album):
        if let selectedSlot = state.selectedSlot {
            state.slots[selectedSlot] = album
        }
    case .removeAlbum(slotIndexes: let slotIndexes):
        for i in slotIndexes {
            state.slots[i] = nil
        }
    case .moveAlbum(from: let from, to: let to):
        state.slots.move(fromOffsets: from, toOffset: to)
    }
    
    return state
}

func updateSearch(state: SearchState, action: SearchAction) -> SearchState {
    var state = state
    
    switch action {
    case .search(for: let term):
        RecordStore.appleMusic.search(term: term, limit: 20, types: [.albums]) { storeResults, error in
            DispatchQueue.main.async {
                store.update(action: SearchAction.populateSearchResults(results: (storeResults?.albums?.data)!))
            }
        }
    case .populateSearchResults(results: let results):
        state.results = results
    case .removeSearchResults:
        state.results = nil
    }
    
    return state
}

