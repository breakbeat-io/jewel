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
    
    init(state: AppState = .init(albums: [Album]())) {
        self.state = state
    }
    
    public func update(action: AppAction) {
        state = applyAction(state: state, action: action)
    }
    
}
