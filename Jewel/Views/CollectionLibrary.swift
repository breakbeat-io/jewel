//
//  CollectionLibrary.swift
//  Listen Later
//
//  Created by Greg Hepworth on 22/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionLibrary: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var collections: [Collection] {
    app.state.library.collections
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      if collections.isEmpty {
        Text("Collections you have saved or that people have shared with you will appear here.")
          .multilineTextAlignment(.center)
          .foregroundColor(Color.secondary)
          .padding()
      } else {
        Text("Collection Library")
          .font(.title)
          .fontWeight(.bold)
        List(collections) { collection in
          CollectionCard(collection: collection)
        }
      }
    }
  }
}
