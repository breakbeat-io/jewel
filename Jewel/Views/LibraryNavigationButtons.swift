//
//  LibraryNavigationButtons.swift
//  Listen Later
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct LibraryNavigationButtonsLeading: View {
  
  @EnvironmentObject var store: AppStore
  
  @State private var showOptions: Bool = false
  
  var body: some View {
    EmptyView()
  }
}

struct LibraryNavigationButtonsTrailing: View {
  
  var body: some View {
    HStack {
      EditButton()
        .padding(.leading)
      Button(action: {
        store.update(action: CollectionAction.toggleActive)
      }) {
        Image(systemName: "music.house" )
      }
      .padding(.leading)
    }
    .padding(.vertical)
  }
}

