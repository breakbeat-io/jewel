//
//  EmptySlot.swift
//  Jewel
//
//  Created by Greg Hepworth on 22/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct EmptySlot: View {
    
    @State private var showingAlert = false
    
    var body: some View {
        Button(action: {
            self.showingAlert = true
        }) {
            RoundedRectangle(cornerRadius: 4)
                .stroke(Color.gray, style: StrokeStyle(lineWidth: 2, dash: [4, 6]))
            .overlay(
                Image(systemName: "plus.app")
                    .font(.title)
                    .foregroundColor(Color.gray)
            )
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Soon you'll be adding your own albums!"), dismissButton: .cancel(Text("Can't wait!")))
        }
    }
}

struct EmptySlot_Previews: PreviewProvider {
    static var previews: some View {
        EmptySlot()
    }
}
