//
//  LibraryButtons.swift
//  Listen Later
//
//  Created by Greg Hepworth on 08/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct LibraryButtons: View {
  
  @Binding var isEditing: Bool
  
  var body: some View {
    Button(action: {
      self.isEditing.toggle()
    }) {
      Text(isEditing ? "Done" : "Edit")
    }
  }
}
