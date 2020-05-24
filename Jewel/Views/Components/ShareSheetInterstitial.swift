//
//  ShareSheetInterstitial.swift
//  Jewel
//
//  Created by Greg Hepworth on 24/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct ShareSheetInterstitial: View {
    
    @EnvironmentObject var collections: Collections
    
    var body: some View {
        Group {
            if collections.activeCollection.shareLinkError {
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                    Text("There was an error creating the shareable link, please try again later.")
                        .padding()
                        .multilineTextAlignment(.center)
                }
            } else if collections.activeCollection.shareLinkShort == nil {
                VStack {
                    Image(systemName: "square.and.arrow.up")
                        .font(.largeTitle)
                    Text("Creating shareable link ...")
                        .padding()
                        .multilineTextAlignment(.center)
                }
            } else {
                ShareSheet(activityItems: [collections.activeCollection.shareLinkShort!])
            }
        }
        .onAppear {
            self.collections.activeCollection.generateShareLinks()
        }
    }
}

struct ShareSheetInterstitial_Previews: PreviewProvider {
    static var previews: some View {
        ShareSheetInterstitial()
    }
}
