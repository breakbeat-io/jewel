//
//  SlotDetail.swift
//  Jewel
//
//  Created by Greg Hepworth on 04/05/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import HMV

struct SlotDetail: View {
    
    @Environment(\.presentationMode) var presentationMode // Needed here as SwiftUI bug will disable navigation buttons if any subview under here dismisses a sheet https://stackoverflow.com/a/61311279
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var searchProvider: SearchProvider
    
    var slotIndex: Int
    
    var body: some View {
        IfLet(userData.activeCollection.slots[slotIndex].source?.content) { content in
            ScrollView {
                if self.horizontalSizeClass == .compact {
                    SourceDetailCompact(slotIndex: self.slotIndex)
                } else {
                    SourceDetailRegular(slotIndex: self.slotIndex)
                }
            }
        }
        .navigationBarItems(trailing:
            SlotDetailButtons(slotIndex: slotIndex)
        )
    }
}

