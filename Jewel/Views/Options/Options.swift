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
    @State private var newCollectionName = ""
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
                                userData.collectionName,
                                text: $newCollectionName,
                                onCommit: {
                                    self.userData.collectionName = self.newCollectionName
                                    self.userData.saveUserData()
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            ).foregroundColor(.blue)
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
                    if userData.debugMode {
                        Section(header: Text("Debug")) {
                            Button(action: {
                                self.userData.loadScreenshotCollection()
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Load Screenshot Data")
                            }
                        }
                    }
                }
                Spacer()
                Footer()
                    .onTapGesture(count: 10) {
                        self.userData.debugMode = true
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
    }
}

struct Options_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        Options().environmentObject(userData)
    }
}
