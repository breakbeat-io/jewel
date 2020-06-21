//
//  Home.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct OldOnRotation: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  private var collectionId: UUID {
    app.state.library.onRotation.id
  }
  
  var body: some View {
    CollectionDetail(collectionId: collectionId)
  }
}
