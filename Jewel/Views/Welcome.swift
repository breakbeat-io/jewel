//
//  Welcome.swift
//  Listen Later
//
//  Created by Greg Hepworth on 09/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Welcome: View {
  
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  @Environment(\.verticalSizeClass) var verticalSizeClass
  
  @EnvironmentObject var environment: AppEnvironment
  
  private let heading = "Welcome!"
  private let description = """
  Listen Later is a place to store albums you want to listen to later.

  Add and remove albums from any of 8 slots as you think of them, and they'll be there waiting for you when you're ready to listen!

  Send your collection to friends and find out what they're listening to by asking them to send their collection to you.

  Build a Collection Library of your and your friends collections for easy play back later!
  """
  private let buttonLabel = "Start My Collection"
  
  var body: some View {
    GeometryReader { geo in
      ZStack {
        Rectangle()
          .fill(Color(.systemBackground))
          .frame(width: self.responsiveWidth(viewWidth: geo.size.width), height: self.responsiveHeight(viewHeight: geo.size.height))
          .cornerRadius(20)
          .shadow(radius: 5)
        VStack(alignment: .leading, spacing: 0) {
          Text(self.heading)
            .font(.title)
            .padding(.top, 50)
            .padding(.bottom, 5)
            .frame(maxWidth: .infinity, alignment: .center)
          ZStack(alignment: .top) {
            GeometryReader { geo in
              ScrollView {
                Text(self.description)
                  .frame(maxWidth: .infinity)
                  .padding(.vertical, 5)
              }
              .padding(.horizontal)
              Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color(.systemBackground), Color(.systemBackground).opacity(0)]), startPoint: .top, endPoint: .bottom))
                .frame(height: 10)
              Rectangle()
                .fill(LinearGradient(gradient: Gradient(colors: [Color(.systemBackground).opacity(0), Color(.systemBackground)]), startPoint: .top, endPoint: .bottom))
                .frame(height: 10)
                .offset(y: geo.size.height - 10)
            }
            
          }
          Button(action: {
            self.environment.update(action: OptionsAction.firstTimeRun(false))
          }) {
            Text(self.buttonLabel)
          }
          .frame(maxWidth: .infinity, alignment: .center)
          .padding()
        }
        .frame(width: self.responsiveWidth(viewWidth: geo.size.width), height: self.responsiveHeight(viewHeight: geo.size.height))
        Image("primary-logo")
          .resizable()
          .frame(width: 75, height: 75)
          .cornerRadius(5)
          .shadow(radius: 3)
          .offset(y: -(self.responsiveHeight(viewHeight: geo.size.height)/2))
      }
    }
  }
  
  private func responsiveWidth(viewWidth: CGFloat) -> CGFloat {
    if horizontalSizeClass == .compact {
      return viewWidth * 0.8
    } else {
      return 400
    }
  }
  
  private func responsiveHeight(viewHeight: CGFloat) -> CGFloat {
    if verticalSizeClass == .compact {
      return viewHeight - 85
    } else if horizontalSizeClass == .compact {
      return viewHeight * 0.7
    } else {
      return 450
    }
  }
}
