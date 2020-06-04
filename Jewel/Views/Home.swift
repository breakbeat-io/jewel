//
//  Home.swift
//  Listen Later
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Home: View {
  
  @EnvironmentObject var store: AppStore
  
  var body: some View {
    NavigationView {
      Group {
        if store.state.collection.active {
          Collection()
        } else {
          Library()
        }
      }
    }
  }
}
