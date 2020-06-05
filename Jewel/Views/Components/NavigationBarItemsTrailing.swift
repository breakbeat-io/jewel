//
//  NavigationBarItemsTrailing.swift
//  Listen Later
//
//  Created by Greg Hepworth on 05/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct NavigationBarItemsTrailing: View {
  @EnvironmentObject var store: AppStore
  
  var body: some View {
    HStack {
      EditButton()
        .padding(.leading)
      Button(action: {
        self.store.update(action: CollectionAction.toggleActive)
      }) {
        Image(systemName: "arrow.2.squarepath" )
      }
      .padding(.leading)
    }
    .padding(.vertical)
  }
}
