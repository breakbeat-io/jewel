//
//  NewAdditionalPlaybackLinks.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct AlternativePlaybackLinks: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  let playbackLinks: OdesliResponse
  
  private var availablePlatforms: [OdesliPlatform] {
    OdesliPlatform.allCases.filter { playbackLinks.linksByPlatform[$0.rawValue] != nil }
  }
  
  var body: some View {
    NavigationView {
      VStack {
        List(availablePlatforms, id: \.self) { platform in
          IfLet(self.playbackLinks.linksByPlatform[platform.rawValue]) { platformLink in
            Button {
              UIApplication.shared.open(platformLink.url)
            } label: {
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
        Button {
          UIApplication.shared.open(URL(string: "https://odesli.co")!)
        } label: {
          Text("Platform links powered by Songlink")
            .foregroundColor(.secondary)
            .font(.footnote)
        }.padding(.vertical)
      }
      .navigationBarTitle("Play in ...", displayMode: .inline)
      .navigationBarItems(
        leading:
          Button {
            self.app.update(action: NavigationAction.showAlternativeLinks(false))
          } label: {
            Text("Close")
          }
      )
    }
    .navigationViewStyle(StackNavigationViewStyle())
  }
}
