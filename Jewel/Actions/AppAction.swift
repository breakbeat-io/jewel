//
//  Action.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

func updateState(state: AppState, action: AppAction) -> AppState {
    return AppState(
        collection: updateCollection(state: state.collection, action: action),
        search: updateSearch(state: state.search, action: action)
    )
}

func updateCollection(state: CollectionState, action: AppAction) -> CollectionState {
    var state = state
    
    switch action {
    case .addAlbum(let album):
        state.albums.append(album)
    case .removeAlbum(let indexSet):
        state.albums.remove(atOffsets: indexSet)
    default: break
    }
    
    return state
}

func updateSearch(state: SearchState, action: AppAction) -> SearchState {
    var state = state
    
    switch action {
    case .search(let term):
        Store.appleMusic.search(term: term, limit: 20, types: [.albums]) { storeResults, error in
            DispatchQueue.main.async {
                store.update(action: .populateSearchResults(results: (storeResults?.albums?.data)!))
            }
        }
    case .populateSearchResults(let results):
        state.results = results
    case .removeSearchResults:
        state.results = nil
    default: break
    }
    
    return state
}

