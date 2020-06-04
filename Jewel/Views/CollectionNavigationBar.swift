//
//  HomeButtonsLeading.swift
//  Jewel
//
//  Created by Greg Hepworth on 01/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct HomeButtonsLeading: View {
  
  @EnvironmentObject var store: AppStore
  
  @State private var showOptions: Bool = false
  
  var body: some View {
    Button(action: {
      self.showOptions = true
    }) {
      Image(systemName: "slider.horizontal.3")
    }.sheet(isPresented: self.$showOptions) {
      Options(showing: self.$showOptions)
        .environmentObject(self.store)
    }
    .padding(.trailing)
    .padding(.vertical)
  }
}

struct HomeButtonsTrailing: View {
  
  var body: some View {
    EditButton()
      .padding(.leading)
      .padding(.vertical)
  }
}
