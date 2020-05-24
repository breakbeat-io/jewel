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
        Group {
            if userData.activeCollection.shareLinkError {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                    Text("There was an error creating the shareable link, please try again later.")
                        .padding()
                        .multilineTextAlignment(.center)
                }
            } else if userData.activeCollection.shareLinkShort == nil {
                VStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.largeTitle)
                    Text("Creating shareable link ...")
                        .padding()
                        .multilineTextAlignment(.center)
                }
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
