//
//  OnRotation.swift
//  Listen Later
//
//  Created by Greg Hepworth on 21/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct OnRotation: View {
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("On Rotation")
        .font(.title)
        .fontWeight(.bold)
      Text("by hepto")
        .font(.subheadline)
        .fontWeight(.light)
      GeometryReader { geo in
        VStack(spacing: 5) {
          ForEach((0...7).reversed(), id: \.self) { album in
            RoundedRectangle(cornerRadius: 8)
              .foregroundColor(Color(UIColor.secondarySystemBackground))
              .frame(height: (geo.size.height / 8) - 5 )
          }
        }
      }
    }
  }
}
