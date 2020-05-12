//
//  AlternativePlaybackLinks.swift
//  Jewel
//
//  Created by Greg Hepworth on 12/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import Grid

struct AdditionalPlaybackLinks: View {
    
    @EnvironmentObject var userData: UserData
    var slotId: Int
    
    var body: some View {
        Grid(OdesliPlatform.allCases, id: \.self) { platform in
            IfLet(self.userData.collection[self.slotId].playbackLinks?.linksByPlatform[platform.rawValue]?.url) { url in
                Button(action: {
                    UIApplication.shared.open(url)
                }) {
                    Group {
                        IfLet(platform.iconRef) { logo in
                            Text(verbatim: logo)
                            .font(.custom("FontAwesome5Brands-Regular", size: 16))
                        }
                        Text(platform.friendlyName)
                    }
                    .font(.callout)
                    .foregroundColor(.secondary)
                }
                .padding()
                .foregroundColor(.primary)
            }
        }
        .padding(.vertical)
        .gridStyle(
            ModularGridStyle(columns: 2, rows: .min(40))
        )
    }
}

struct AlternativePlaybackLinks_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        AdditionalPlaybackLinks(slotId: 0).environmentObject(userData)
    }
}
