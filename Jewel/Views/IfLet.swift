//
//  IfLet.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct IfLet<Value, Content: View>: View {
  private let value: Value?
  private let contentProvider: (Value) -> Content
  
  init(_ value: Value?,
       @ViewBuilder content: @escaping (Value) -> Content) {
    self.value = value
    self.contentProvider = content
  }
  
  var body: some View {
    value.map(contentProvider)
  }
}
