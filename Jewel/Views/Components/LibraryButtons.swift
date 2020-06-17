//
//  LibraryButtons.swift
//  Listen Later
//
//  Created by Greg Hepworth on 08/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct LibraryButtons: View {
  
  @EnvironmentObject var environment: AppEnvironment
  
  @Binding var selectedTab: String
  @Binding var isEditing: Bool
  
  var body: some View {
    HStack {
      if selectedTab == "library" {
        Button(action: {
          self.environment.update(action: LibraryAction.addUserCollection)
        }) {
          Image(systemName: "plus")
        }
        .padding(.trailing)
      }
      Button(action: {
        self.isEditing.toggle()
      }) {
        Text(isEditing ? "Done" : "Edit")
      }
    }
    .padding(.vertical)
  }
}
