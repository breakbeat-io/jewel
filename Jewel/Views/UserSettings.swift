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
    @State var isActive : Bool = false
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            NavigationView {
                List {
                    NavigationLink(destination:
                        WalletName(newWalletName: self.$newWalletName, shouldPopToRootView: self.$isActive),
                        isActive: self.$isActive) {
                        HStack {
                            Text("Wallet Name")
                            Spacer()
                            Text(userData.walletName)
                            .foregroundColor(Color.secondary)
                        }
                    }
                    .isDetailLink(false)
                }
                .navigationBarTitle("Settings")
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
}

struct UserSettings_Previews: PreviewProvider {
    static var previews: some View {
        UserSettings()
    }
}
