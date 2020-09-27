//
//  Settings.swift
//  Listen Later
//
//  Created by Greg Hepworth on 18/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct SettingsHome: View {
  
  @EnvironmentObject private var app: AppEnvironment
  
  @State private var newCurator: String = ""

  private var curator: Binding<String> { Binding (
    get: { self.app.state.library.onRotation.curator },
    set: { self.newCurator = $0 }
    )}
  private var preferredMusicPlatform: Binding<Int> { Binding (
    get: { self.app.state.settings.preferredMusicPlatform },
    set: { self.app.update(action: SettingsAction.setPreferredPlatform(platform: $0)) }
    )
  }
  
  var body: some View {
    NavigationView {
      VStack {
        Form {
          Section(footer: Text("Use this Curator name when sharing your On Rotation collection and when creating new collections.")) {
            HStack {
              Text("Curator")
              TextField(
                curator.wrappedValue,
                text: curator,
                onEditingChanged: { _ in
                  if !self.newCurator.isEmpty && self.newCurator != self.app.state.library.onRotation.curator {
                    self.app.update(action: LibraryAction.setCollectionCurator(curator: self.newCurator.trimmingCharacters(in: .whitespaces), collectionId: self.app.state.navigation.onRotationId!))
                  }
                }
              ).foregroundColor(.accentColor)
            }
          }
          Section(footer: Text("Use this service for playback if available, otherwise use Apple Music.")) {
            Picker(selection: preferredMusicPlatform, label: Text("Playback Service")) {
              ForEach(0 ..< OdesliPlatform.allCases.count, id: \.self) {
                Text(OdesliPlatform.allCases[$0].friendlyName)
              }
            }
          }
          if app.state.navigation.showDebugMenu {
            Section(header: Text("Debug")) {
              Button {
                RecordStore.loadScreenshotCollection()
                self.app.update(action: NavigationAction.showSettings(false))
              } label: {
                Text("Load Screenshot Data")
              }
              Button {
                self.app.update(action: SettingsAction.reset)
              } label: {
                Text("Reset Jewel")
                  .foregroundColor(.red)
              }
            }
          }
        }
        Spacer()
        Footer()
          .onTapGesture(count: 10) {
            self.app.update(action: NavigationAction.toggleDebug)
          }
          .padding()
      }
      .navigationBarTitle("Settings", displayMode: .inline)
      .navigationBarItems(
        leading:
        Button {
          self.app.update(action: NavigationAction.showSettings(false))
        } label: {
          Text("Close")
        }
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct SettingsButton: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var showSettings: Binding<Bool> { Binding (
    get: { self.app.state.navigation.showSettings },
    set: { if self.app.state.navigation.showSettings { self.app.update(action: NavigationAction.showSettings($0)) } }
  )}
  
  var body: some View {
    HStack {
      Button {
        self.app.update(action: NavigationAction.showSettings(true))
      } label: {
        Image(systemName: "gear")
          .foregroundColor(Color(UIColor.secondaryLabel))
      }
      Spacer()
    }
    .padding(.vertical)
    .frame(width: Constants.buttonWidth)
    .sheet(isPresented: showSettings) {
      SettingsHome()
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
