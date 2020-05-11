//
//  LinkProvider.swift
//  Jewel
//
//  Created by Greg Hepworth on 10/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

class LinkProvider: ObservableObject {
    
    @Published var links: OdesliResponse?
    
    func getServiceLinks(appleMusicUrl: URL) {
        
        let request = URLRequest(url: URL(string: "https://api.song.link/v1-alpha.1/links?url=\(appleMusicUrl.absoluteString)")!)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode(OdesliResponse.self, from: data) {
                    DispatchQueue.main.async {
                        self.links = decodedResponse
                    }
                }
            }

            // if we're still here it means there was a problem
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}
