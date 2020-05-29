//
//  Action.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

func applyAction(state: AppState, action: AppAction) -> AppState {
    var state = state
    
    switch action {
    case .addAlbum(let album):
        state.albums.append(album)
    case .removeAlbum(let indexSet):
        state.albums.remove(atOffsets: indexSet)
    }
    
    return state
    
}
