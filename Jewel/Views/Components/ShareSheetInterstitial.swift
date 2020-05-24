//
//  ShareSheetInterstitial.swift
//  Jewel
//
//  Created by Greg Hepworth on 24/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct ShareSheetInterstitial: View {
    
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        ZStack {
            if userData.activeCollection.shareLinkLong == nil {
                Text("generating share link")
            } else {
                Text("longLink exists!")
            }
        }
        .onAppear {
            self.userData.activeCollection.generateShareLinks()
        }
    }
}

struct ShareSheetInterstitial_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheetInterstitial()
    }
}
