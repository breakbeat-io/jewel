//
//  Options.swift
//  Jewel
//
//  Created by Greg Hepworth on 04/05/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct Options: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userData: UserData
    @State private var showDeleteAllWarning = false
    @State private var showLoadRecommendationsAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Collection Name")
                            TextField(
                                userData.collection.name,
                                text: $userData.collection.name,
                                onCommit: {
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            ).foregroundColor(.blue)
                        }
                    }
                    Section(footer: Text("If available, use this service for playback, otherwise use Apple Music.")) {
                        Picker(selection: $userData.prefs.preferredMusicPlatform, label: Text("Preferred Playback Service")) {
                            ForEach(0 ..< OdesliPlatform.allCases.count, id: \.self) {
                                Text(OdesliPlatform.allCases[$0].friendlyName)
                            }
                        }
                    }
                    Section(footer: Text("Load a selection of recent and classic releases, chosen by the music lovers that make Jewel.")) {
                        Button(action: {
                            self.showLoadRecommendationsAlert = true
                        }) {
                            Text("Load Recommendations")
                        }
                        .alert(isPresented: $showLoadRecommendationsAlert) {
                            Alert(title: Text("Are you sure you want to load our recommendations?"),
                                  message: Text("This will remove your current collection."),
                                  primaryButton: .cancel(Text("Cancel")),
                                  secondaryButton: .default(Text("Load").bold()) {
                                    self.userData.loadRecommendations()
                                    self.presentationMode.wrappedValue.dismiss()
                                })
                        }
                    }
                    Button(action: {
                        self.showDeleteAllWarning = true
                    }) {
                        Text("Delete All")
                    }
                    .foregroundColor(.red)
                    .alert(isPresented: $showDeleteAllWarning) {
                        Alert(title: Text("Are you sure you want to delete all albums in your collection?"),
                              message: Text("You cannot undo this operation."),
                              primaryButton: .cancel(Text("Cancel")),
                              secondaryButton: .destructive(Text("Delete")) {
                                self.userData.deleteAll()
                                self.presentationMode.wrappedValue.dismiss()
                            })
                    }
                    if userData.prefs.debugMode {
                        Section(header: Text("Debug")) {
                            Button(action: {
                                self.userData.loadScreenshotCollection()
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Load Screenshot Data")
                            }
                            Button(action: {
                                self.userData.reset()
                                self.presentationMode.wrappedValue.dismiss()
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
                        self.userData.prefs.debugMode.toggle()
                    }
                .padding()
            }
            .navigationBarTitle("Options", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onDisappear {
            self.userData.collectionChanged()
            self.userData.preferencesChanged()
        }
    }
}

struct Options_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        Options().environmentObject(userData)
    }
}
