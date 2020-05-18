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
    @State private var showEjectMyCollectionWarning = false
    @State private var showEjectSharedCollectionWarning = false
    @State private var showLoadRecommendationsAlert = false
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(footer: Text("Choose a name for your collection, and to represent the curator when sharing the collection.")) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Collection Name")
                            TextField(
                                userData.userCollection.name,
                                text: $userData.userCollection.name,
                                onCommit: {
                                    self.presentationMode.wrappedValue.dismiss()
                            }
                            ).foregroundColor(.accentColor)
                        }
                        HStack(alignment: .firstTextBaseline) {
                            Text("Curator")
                            TextField(
                                userData.userCollection.curator,
                                text: $userData.userCollection.curator,
                                onCommit: {
                                    self.presentationMode.wrappedValue.dismiss()
                            }
                            ).foregroundColor(.accentColor)
                        }
                    }
                    Section(footer: Text("If available, use this service for playback, otherwise use Apple Music.")) {
                        Picker(selection: $userData.prefs.preferredMusicPlatform, label: Text("Playback Service")) {
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
                                  message: Text("This will replace your current shared collection."),
                                  primaryButton: .cancel(Text("Cancel")),
                                  secondaryButton: .default(Text("Load").bold()) {
                                    self.userData.getRecommendations()
                                    self.presentationMode.wrappedValue.dismiss()
                                })
                        }
                    }
                    Section(header: Text("SYSTEM")) {
                        Button(action: {
                            self.showEjectMyCollectionWarning = true
                        }) {
                            Text("Eject My Collection")
                        }
                        .foregroundColor(.red)
                        .alert(isPresented: $showEjectMyCollectionWarning) {
                            Alert(title: Text("Are you sure you want to eject all the albums in your collection?"),
                                  message: Text("You cannot undo this operation."),
                                  primaryButton: .cancel(Text("Cancel")),
                                  secondaryButton: .destructive(Text("Eject All")) {
                                    self.userData.ejectUserCollection()
                                    self.presentationMode.wrappedValue.dismiss()
                                })
                        }
                        Button(action: {
                            self.showEjectSharedCollectionWarning = true
                        }) {
                            Text("Eject Shared Collection")
                        }
                        .foregroundColor(.red)
                        .alert(isPresented: $showEjectSharedCollectionWarning) {
                            Alert(title: Text("Are you sure you want to eject your current shared collection?"),
                                  message: Text("You cannot undo this operation."),
                                  primaryButton: .cancel(Text("Cancel")),
                                  secondaryButton: .destructive(Text("Eject Shared")) {
                                    self.userData.ejectSharedCollection()
                                    self.presentationMode.wrappedValue.dismiss()
                                })
                        }
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
