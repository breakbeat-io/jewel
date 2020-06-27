//
//  Settings.swift
//  Listen Later
//
//  Created by Greg Hepworth on 18/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Settings: View {
  
  @EnvironmentObject private var app: AppEnvironment
  
  private var curator: Binding<String> { Binding (
    get: { self.app.state.options.defaultCurator },
    set: { self.app.update(action: OptionsAction.setDefaultCurator(curator: $0))}
    )}
  private var preferredMusicPlatform: Binding<Int> { Binding (
    get: { self.app.state.options.preferredMusicPlatform },
    set: { self.app.update(action: OptionsAction.setPreferredPlatform(platform: $0)) }
    )
  }
  
  var body: some View {
    NavigationView {
      VStack {
        Form {
          HStack {
            Text("Curator")
            TextField(
              curator.wrappedValue,
              text: curator,
              onCommit: {
                self.app.navigation.showSettings = false
            }
            ).foregroundColor(.accentColor)
          }
          Section(footer: Text("Use this service for playback if available, otherwise use Apple Music.")) {
            Picker(selection: preferredMusicPlatform, label: Text("Playback Service")) {
              ForEach(0 ..< OdesliPlatform.allCases.count, id: \.self) {
                Text(OdesliPlatform.allCases[$0].friendlyName)
              }
            }
          }
          if app.navigation.showDebugMenu {
            Section(header: Text("Debug")) {
              Button(action: {
                RecordStore.loadScreenshotCollection()
                self.app.navigation.showSettings = false
              }) {
                Text("Load Screenshot Data")
              }
              Button(action: {
                self.app.update(action: OptionsAction.reset)
              }) {
                Text("Reset Jewel")
                  .foregroundColor(.red)
              }
            }
          }
        }
        Spacer()
        Footer()
          .onTapGesture(count: 10) {
            self.app.navigation.showDebugMenu.toggle()
          }
          .padding()
      }
      .navigationBarTitle("Settings", displayMode: .inline)
      .navigationBarItems(
        leading:
        Button(action: {
          self.app.navigation.showSettings = false
        }) {
          Text("Close")
        }
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct SettingsButton: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var body: some View {
    HStack {
      Button(action: {
        self.app.navigation.showSettings = true
      }) {
        Image(systemName: "gear")
      }
      Spacer()
    }
    .padding(.vertical)
    .frame(width: Constants.buttonWidth)
    .sheet(isPresented: $app.navigation.showSettings) {
        Settings()
          .environmentObject(self.app)
    }
  }
}

struct Footer: View {
  var body: some View {
    VStack {
      Text("🎵 + 📱 = 🙌")
        .padding(.bottom)
      Text("© 2020 Breakbeat Ltd.")
      Text(Bundle.main.buildNumber)
        .foregroundColor(Color.secondary)
    }
    .font(.footnote)
  }
}
