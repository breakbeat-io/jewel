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
  
  @Binding var isEditing: Bool
  
  var body: some View {
    HStack {
      if !environment.state.library.onRotationActive {
        Button(action: {
          
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
