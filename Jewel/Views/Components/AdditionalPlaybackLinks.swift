//
//  AlternativePlaybackLinks.swift
//  Jewel
//
//  Created by Greg Hepworth on 12/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct AdditionalPlaybackLinks: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userData: UserData
    
    var slotIndex: Int
    private var availablePlatforms: [OdesliPlatform] {
        OdesliPlatform.allCases.filter { userData.activeCollection.slots[slotIndex].playbackLinks?.linksByPlatform[$0.rawValue] != nil }
    }
    private var platformLinks: [String : OdesliLink]? {
        userData.activeCollection.slots[slotIndex].playbackLinks?.linksByPlatform
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(availablePlatforms, id: \.self) { platform in
                    IfLet(self.platformLinks?[platform.rawValue]) { platformLink in
                        Button(action: {
                            UIApplication.shared.open(platformLink.url)
                        }) {
                            HStack {
                                Group {
                                    if platform.iconRef != nil {
                                        Text(verbatim: platform.iconRef!)
                                            .font(.custom("FontAwesome5Brands-Regular", size: 16))
                                    } else {
                                        Image(systemName: "arrowshape.turn.up.right")
                                    }
                                }
                                .frame(width: 40, alignment: .center)
                                .foregroundColor(.secondary)
                                Text(platform.friendlyName)
                                    .foregroundColor(.primary)
                            }
                        }
                    }
                }
                Button(action: {
                    UIApplication.shared.open(URL(string: "https://odesli.co")!)
                }) {
                    Text("Platform links powered by Songlink")
                        .foregroundColor(.secondary)
                        .font(.footnote)
                }.padding(.vertical)
            }
            .navigationBarTitle("Play in ...", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Close")
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
