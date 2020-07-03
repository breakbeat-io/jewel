//
//  EmptySlot.swift
//  Jewel
//
//  Created by Greg Hepworth on 01/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct AddSourceCardButton: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  let slotIndex: Int
  let collectionId: UUID
  
  private var showSearch: Binding<Bool> { Binding (
    get: { self.app.state.navigation.showSearch },
    set: { self.app.update(action: NavigationAction.showSearch($0))}
  )}
  
  var body: some View {
    Button(action: {
      self.app.update(action: NavigationAction.showSearch(true))
    }) {
      RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
        .foregroundColor(Color(UIColor.secondarySystemBackground))
        .overlay(
          Image(systemName: "plus")
            .font(.headline)
            .foregroundColor(Color.secondary)
      )
    }
    .sheet(isPresented: showSearch) {
      SearchHome(collectionId: self.collectionId, slotIndex: self.slotIndex)
        .environmentObject(self.app)
    }
  }
}
