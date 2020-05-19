//
//  SearchProvider.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import Foundation
import HMV

class SearchProvider: ObservableObject {
    
    @Published var results: [Album]?
    
    func search(searchTerm: String) {
        Store.appleMusic.search(term: searchTerm, limit: 20, types: [.albums]) { storeResults, error in
            DispatchQueue.main.async {
                self.results = storeResults?.albums?.data
            }
        }
    }
}
