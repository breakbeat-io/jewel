//
//  EmptySlot.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct EmptySlot: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 10)
        .stroke(style: StrokeStyle(lineWidth: 3.0, lineCap: .round, dash: [5, 10]))
        .overlay(
            Image(systemName: "plus.app")
                .font(.largeTitle)
        )
    }
}

struct EmptySlot_Previews: PreviewProvider {
    static var previews: some View {
        EmptySlot()
    }
}
