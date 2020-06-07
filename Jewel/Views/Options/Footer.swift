//
//  Footer.swift
//  Jewel
//
//  Created by Greg Hepworth on 31/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Footer: View {
  var body: some View {
    VStack {
      Text("🎵 + 📱 = 🙌")
        .padding(.bottom)
      Text("© 2020 Breakbeat Ltd.")
      Text(Bundle.main.buildNumber)
        .foregroundColor(Color.secondary)
    }
    .font(.footnote)
  }
}
