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
  
  var body: some View {
    Button {
      self.app.update(action: NavigationAction.setActiveCollectionId(collectionId: self.collectionId))
      self.app.update(action: NavigationAction.setActiveSlotIndex(slotIndex: self.slotIndex))
      self.app.update(action: NavigationAction.showSearch(true))
    } label: {
      RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
        .foregroundColor(Color(UIColor.secondarySystemBackground))
        .overlay(
          Image(systemName: "plus")
            .font(.headline)
            .foregroundColor(Color.secondary)
      )
    }
  }
}
