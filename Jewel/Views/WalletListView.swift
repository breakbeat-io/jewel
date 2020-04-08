//
//  CollectionListView.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct WalletListView: View {
    
    let wallets = ["Road Trip", "Garden", "New Releases"]
    
    var body: some View {
        NavigationView {
            List(wallets, id: \.self) { wallet in
                NavigationLink(
                    destination: WalletView(wallet: wallet)) {
                        Text(wallet)
                    }
            }
            .navigationBarTitle("Wallets")
        }
    }
}

struct CollectionListView_Previews: PreviewProvider {
    static var previews: some View {
        WalletListView()
    }
}
