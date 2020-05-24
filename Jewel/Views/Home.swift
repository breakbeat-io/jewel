//
//  Home.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct Home: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var preferences: Preferences
    @EnvironmentObject var collections: Collections
    
    @State private var showOptions = false
    @State private var showShareSheet = false
    
    private var slots: [Slot] {
        collections.activeCollection.slots
    }
    
    var body: some View {
        ZStack {
            NavigationView {
                GeometryReader { geo in
                    List(self.slots.indices, id: \.self) { slotIndex in
                        Group {
                            if self.slots[slotIndex].source?.content != nil {
                                FilledSlot(slotIndex: slotIndex)
                            } else {
                                EmptySlot(slotIndex: slotIndex)
                            }
                        }
                        .frame(height: (geo.size.height - geo.safeAreaInsets.top - geo.safeAreaInsets.bottom) / CGFloat(self.slots.count))
                    }
                    .onAppear {
                        UITableView.appearance().separatorStyle = .none
                    }
                    .navigationBarTitle(self.collections.activeCollection.name)
                    .navigationBarItems(
                        leading:
                        HomeButtonsLeading()
                        ,trailing:
                        HomeButtonsTrailing()
                    )
                }
                .alert(isPresented: $collections.sharedCollectionCued) {
                    Alert(title: Text("Shared collection received from \(collections.candidateCollection?.curator ?? "a discerning curator")!"),
                          message: Text("Would you like to replace your current shared collection?"),
                          primaryButton: .cancel(Text("Cancel")),
                          secondaryButton: .default(Text("Replace").bold()) {
                            self.collections.loadCandidateCollection()
                            self.presentationMode.wrappedValue.dismiss()
                        })
                }
                Start()
            }
            .blur(radius: preferences.firstTimeRun ? 2 : 0)
            if preferences.firstTimeRun {
                Welcome()
            }
        }
        .statusBar(hidden: true)
    }
}
