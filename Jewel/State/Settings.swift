//
//  OptionsState.swift
//  Listen Later
//
//  Created by Greg Hepworth on 02/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

struct Settings: Codable {
  var preferredMusicPlatform: Int = 0
  var firstTimeRun: Bool = true
}
