//
//  WalletName.swift
//  Jewel
//
//  Created by Greg Hepworth on 04/05/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct WalletName: View {
    
    @EnvironmentObject var userData: UserData
    
    @Binding var newWalletName: String
    @Binding var shouldPopToRootView: Bool
    
    var body: some View {
        VStack {
            HStack {
                TextField(
                    userData.walletName,
                    text: $newWalletName,
                    onCommit: {
                        self.userData.walletName = self.newWalletName
                        self.shouldPopToRootView = false
                    }
                ).padding()
                    .background(Color.white)
                Button(action: {
                    self.newWalletName = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                }
                .foregroundColor(.secondary)
                .background(Color(.secondarySystemBackground))
            }
            Spacer()
        }
        .padding(.vertical)
        .background(Color(.secondarySystemBackground))
        .navigationBarTitle("Wallet Name")
    }
}

//struct WalletName_Previews: PreviewProvider {
//    static var previews: some View {
//        WalletName()
//    }
//}
