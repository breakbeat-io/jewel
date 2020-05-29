//
//  AddButton.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct AddButton: View {
    
    @Binding var isAddingMode: Bool
    
    var body: some View {
        Button(action: {
            self.isAddingMode = true
        }) {
            Image(systemName: "plus")
        }
    }
}

//struct AddButton_Previews: PreviewProvider {
//    static var previews: some View {
//        AddButton()
//    }
//}
