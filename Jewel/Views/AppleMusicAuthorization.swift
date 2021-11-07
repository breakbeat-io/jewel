//
//  AppleMusicAuthorization.swift
//  Listen Later
//
//  Created by Greg Hepworth on 07/11/2021.
//  Copyright © 2021 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import MusicKit

struct AppleMusicAuthorization: View {
  
  @Environment(\.openURL) private var openURL
  
  @Binding var appleMusicAuthorizationStatus: MusicAuthorization.Status
  
  var body: some View {
    VStack {
      Image("primary-logo")
        .resizable()
        .frame(width: 75, height: 75)
        .cornerRadius(5)
        .shadow(radius: 3)
        .padding(.bottom)
      authorizationStatement
        .font(.title2)
        .multilineTextAlignment(.center)
        .padding([.horizontal, .bottom])
      if appleMusicAuthorizationStatus == .notDetermined || appleMusicAuthorizationStatus == .denied {
        if let action = action {
          action.text
            .foregroundColor(.secondary)
            .font(.title3)
            .multilineTextAlignment(.center)
            .padding([.horizontal, .bottom])
          action.button
            .buttonStyle(.bordered)
        }
      }
    }
  }
  
  private var authorizationStatement: Text {
    switch appleMusicAuthorizationStatus {
    case .restricted:
      return Text("Listen Later cannot be used on this device because usage of ")
      + Text(Image(systemName: "applelogo")) + Text(" Music is restricted.")
    default:
      return Text("Listen Later uses the ")
      + Text(Image(systemName: "applelogo")) + Text(" Music catalogue to browse and save music.")
    }
  }
  
  private var action: (text: Text, button: Button<Text>)? {
    switch appleMusicAuthorizationStatus {
    case .notDetermined:
      return (
        Text("Please authorize Listen Later to access Apple Music."),
        Button {
          Task {
            appleMusicAuthorizationStatus = await MusicAuthorization.request()
          }
        } label: {
          Text("Authorize")
        }
      )
    case .denied:
      return (
        Text("Please allow Listen Later to access\n") + Text(Image(systemName: "applelogo")) + Text(" Music in Settings."),
        Button {
          if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
            openURL(settingsURL)
          }
        } label: {
          Text("Open Settings")
        }
      )
    default:
      return nil
    }
  }
}
