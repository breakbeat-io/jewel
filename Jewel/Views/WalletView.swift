//
//  CircleImage.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import Grid

struct WalletView: View {
    
    @EnvironmentObject var wallet: Wallet
    
    var body: some View {
        NavigationView {
            Grid(wallet.releases) { release in
                NavigationLink(
                    destination: ReleaseDetail (
                        release: release
                    )
                ) {
                ReleaseListItem (
                    release: release
                )
                }
            }
            .padding(6)
            .navigationBarTitle(Text("Wallet"))
        }
        .gridStyle (
            ModularGridStyle(columns: 2, rows: 4)
        )
        .statusBar(hidden: true)
        .accentColor(.black)
    }
}

struct CircleImage_Previews: PreviewProvider {
    static let wallet = Wallet()
    
    static var previews: some View {
        WalletView().environmentObject(wallet)
    }
}
