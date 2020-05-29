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
        collection: updateCollection(state: state.collection, action: action)
    )
}

func updateCollection(state: CollectionState, action: AppAction) -> CollectionState {
    var state = state
    
    switch action {
    case .addAlbum(let album):
        state.albums.append(album)
    case .removeAlbum(let indexSet):
        state.albums.remove(atOffsets: indexSet)
    }
    
    return state
}



