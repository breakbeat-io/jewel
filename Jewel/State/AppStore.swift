//
//  Store.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

final class AppStore: ObservableObject {
    @Published private(set) var state: AppState
    
    init() {
        let collection = CollectionState(albums: [Album]())
        let search = SearchState()
        let appState = AppState(collection: collection, search: search)
        self.state = appState
    }
    
    public func update(action: AppAction) {
        state = updateState(state: state, action: action)
    }
    
}
