//
//  LinkProvider.swift
//  Jewel
//
//  Created by Greg Hepworth on 10/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

class LinkProvider: ObservableObject {
    
    
    static func getServiceLinks(appleMusicUrl: URL) -> OdesliResponse? {
 
        if let url = Bundle.main.url(forResource: "odesli", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let links = try decoder.decode(OdesliResponse.self, from: data)
                return links
            } catch {
                print("error:\(error)")
            }
        }
        return nil
    }
}
