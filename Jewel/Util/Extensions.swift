//
//  Bundle+BuildNumber.swift
//  Jewel
//
//  Created by Greg Hepworth on 31/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import MusicKit

extension Bundle {
  
  var releaseVersionNumber: String? {
    return infoDictionary?["CFBundleShortVersionString"] as? String
  }
  
  var buildVersionNumber: String? {
    return infoDictionary?["CFBundleVersion"] as? String
  }
  
  var buildNumber: String {
    return "v\(releaseVersionNumber ?? "0") (\(buildVersionNumber ?? "0"))"
  }
  
  var displayName: String? {
    return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ??
    object(forInfoDictionaryKey: "CFBundleName") as? String
  }
}


extension String {
  
  func replaceFirstOccurrence(of target: String, with replacement: String) -> String {
    guard let range = range(of: target) else { return self }
    return replacingCharacters(in: range, with: replacement)
  }
  
  func base64Encoded() -> String? {
    return data(using: .utf8)?.base64EncodedString()
  }
  
  func base64Decoded() -> String? {
    guard let data = Data(base64Encoded: self) else { return nil }
    return String(data: data, encoding: .utf8)
  }
}


extension Song {
  
  var durationString: String? {
    guard let duration = duration else { return nil }
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.unitsStyle = .positional
    guard let durationString = formatter.string(from: duration) else { return nil }
    return durationString
  }
  
}
