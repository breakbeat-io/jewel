//
//  AdditionalPlaybackLinks.swift
//  Listen Later
//
//  Created by Greg Hepworth on 02/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct AdditionalPlaybackLinks: View {
    
    @EnvironmentObject var store: AppStore
    
    @Binding var showing: Bool
    
    private var availablePlatforms: [OdesliPlatform] {
        OdesliPlatform.allCases.filter { store.state.collection.slots[store.state.collection.selectedSlot!].playbackLinks?.linksByPlatform[$0.rawValue] != nil }
    }
    private var platformLinks: [String : OdesliLink]? {
        store.state.collection.slots[store.state.collection.selectedSlot!].playbackLinks?.linksByPlatform
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
                    self.showing = false
                }) {
                    Text("Close")
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
