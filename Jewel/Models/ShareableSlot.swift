//
//  ShareableCollection.swift
//  Jewel
//
//  Created by Greg Hepworth on 14/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//
import Foundation

struct ShareableCollection: Codable {
    let schemaName = "jewel-shared-collection"
    let schemaVersion: Decimal = 1.1
    let collectionName: String
    let collectionCurator: String
    let collection: [ShareableSlot?]
    
    enum CodingKeys: String, CodingKey {
        case schemaName = "sn"
        case schemaVersion = "sv"
        case collectionName = "cn"
        case collectionCurator = "cc"
        case collection = "c"
    }
    
}

struct ShareableSlot: Codable {
    let sourceProvider: SourceProvider
    let sourceRef: String
    
    enum CodingKeys: String, CodingKey {
        case sourceProvider = "sp"
        case sourceRef = "sr"
    }
}
