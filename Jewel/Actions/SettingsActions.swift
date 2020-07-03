//
//  SettingsActions.swift
//  Listen Later
//
//  Created by Greg Hepworth on 03/07/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

func updateSettings(settings: Settings, action: SettingsAction) -> Settings {
  
  var newSettings = settings
  
  switch action {
    
  case let .firstTimeRun(firstTimeRunState):
    newSettings.firstTimeRun = firstTimeRunState
    
  case let .setPreferredPlatform(platform):
    newSettings.preferredMusicPlatform = platform
    
  case .reset:
    let domain = Bundle.main.bundleIdentifier!
    UserDefaults.standard.removePersistentDomain(forName: domain)
    UserDefaults.standard.synchronize()
    exit(1)
    
  }
  
  return newSettings
}

enum SettingsAction: AppAction {
  
  case firstTimeRun(_: Bool)
  case setPreferredPlatform(platform: Int)
  case reset
  
  var description: String {
    switch self {
    case .setPreferredPlatform(let platformId):
      return "\(type(of: self)): Setting preferred platform to ID: \(platformId)"
    case .firstTimeRun(let firstTime):
      return "\(type(of: self)): \(firstTime ? "Setting to" : "Clearing") first time run"
    case .reset:
      return "\(type(of: self)): Performing reset"
    }
  }
}
