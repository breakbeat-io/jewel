//
//  LibraryOptions.swift
//  Listen Later
//
//  Created by Greg Hepworth on 18/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct LibraryOptions: View {
  
  @EnvironmentObject private var environment: AppEnvironment
  
  @Binding var showing: Bool
  @Binding var editMode: Bool
  
  private var preferredMusicPlatform: Binding<Int> { Binding (
    get: { self.environment.state.options.preferredMusicPlatform },
    set: { self.environment.update(action: OptionsAction.setPreferredPlatform(platform: $0)) }
    )
  }
  
  var body: some View {
    NavigationView {
      VStack {
        Form {
          Section {
            Button(action: {
              self.editMode = true
              self.showing = false
            }) {
              HStack {
                Image(systemName: "pencil")
                  .frame(width: 30)
                Text("Edit Library")
              }
            }
            .disabled(environment.state.library.collections.isEmpty)
            RecommendationsButton()
          }
          
          Section(header: Text("APP OPTIONS"), footer: Text("Use this service for playback if available, otherwise use Apple Music.")) {
            Picker(selection: preferredMusicPlatform, label: Text("Playback Service")) {
              ForEach(0 ..< OdesliPlatform.allCases.count, id: \.self) {
                Text(OdesliPlatform.allCases[$0].friendlyName)
              }
            }
          }
          if environment.state.options.debugMode {
            Button(action: {
              self.environment.update(action: OptionsAction.reset)
            }) {
              Text("Reset Jewel")
                .foregroundColor(.red)
            }
          }
        }
        Spacer()
        Footer()
          .onTapGesture(count: 10) {
            self.environment.update(action: OptionsAction.toggleDebugMode)
        }
        .padding()
      }
      .navigationBarTitle("Library Options", displayMode: .inline)
      .navigationBarItems(trailing:
        Button(action: {
          self.showing = false
        }) {
          Text("Close")
        }
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}
