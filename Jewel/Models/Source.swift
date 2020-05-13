//
//  Source.swift
//  Jewel
//
//  Created by Greg Hepworth on 13/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

protocol Source: Codable {
    var sourceProvider: SourceProvider { get }
    var sourceReference: String { get set }
}
