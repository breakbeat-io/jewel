//
//  UserSettings.swift
//  Jewel
//
//  Created by Greg Hepworth on 04/05/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct UserSettings: View {
    
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var userData: UserData
    
    @State private var newWalletName = ""
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
                                userData.walletName,
                                text: $newWalletName,
                                onCommit: {
                                    self.userData.walletName = self.newWalletName
                                    self.userData.saveUserData()
                                    self.presentationMode.wrappedValue.dismiss()
                                }
                            )
                        }
                    }
                    Button(action: {
                        self.showDeleteAllWarning = true
                    }) {
                        Text("Delete All")
                    }
                    .foregroundColor(.red)
                    .alert(isPresented: $showDeleteAllWarning) {
                        Alert(title: Text("Are you sure you want to delete all albums in your wallet?"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .destructive(Text("Delete")) {
                                self.userData.deleteAll()
                                self.presentationMode.wrappedValue.dismiss()
                            })
                    }
                    Button(action: {
                        self.showLoadRecommendationsAlert = true
                    }) {
                        Text("Load Recommendations")
                    }.alert(isPresented: $showLoadRecommendationsAlert) {
                        Alert(title: Text("Do you want to load our recommendations?"), primaryButton: .cancel(Text("Cancel")), secondaryButton: .default(Text("Load").bold()) {
                                self.userData.loadRecommendations()
                                self.presentationMode.wrappedValue.dismiss()
                            })
                    }
                }
                Spacer()
                Text("🎵 + 📱 = 🙌")
                    .font(.footnote)
                    .padding(.bottom)
                Text("© 2020 Breakbeat Ltd.")
                    .font(.footnote)
                
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                }
            )

        }
    }
}

struct UserSettings_Previews: PreviewProvider {
    static var previews: some View {
        UserSettings()
    }
}
