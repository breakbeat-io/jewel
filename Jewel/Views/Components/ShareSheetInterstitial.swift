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
            if userData.activeCollection.shareLinkShort == nil {
                Text("Generating share links ...")
            } else {
                ShareSheet(activityItems: [userData.activeCollection.shareLinkShort!])
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
