//
//  Home.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct Home: View {
    
    @EnvironmentObject var userData: UserData
    @State private var showOptions = false
    @State private var showShareSheet = false
    
    private func slotViewForId(slotIndex: Int) -> some View {
        if userData.activeCollection.slots[slotIndex].source?.album == nil {
            return AnyView(EmptySlot(slotIndex: slotIndex))
        } else {
            return AnyView(FilledSlot(slotIndex: slotIndex))
        }
    }
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geo in
                List(self.userData.activeCollection.slots.indices, id: \.self) { index in
                    self.slotViewForId(slotIndex: index)
                        .frame(height: (geo.size.height - geo.safeAreaInsets.top - geo.safeAreaInsets.bottom) / CGFloat(self.userData.activeCollection.slots.count))
                }
                .sheet(isPresented: self.$showOptions) {
                    Options().environmentObject(self.userData)
                }
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                }
                .navigationBarTitle(self.userData.activeCollection.name)
                .navigationBarItems(leading:
                    Button(action: {
                        self.showOptions = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .padding()
                    }
                    ,trailing:
                    HStack {
                        Button(action: {
                            self.showShareSheet = true
                        }) {
                            Image(systemName: "square.and.arrow.up")
                                .padding()
                        }
                        .sheet(isPresented: self.$showShareSheet) {
                            ShareSheet(activityItems: [self.userData.createShareUrl()])
                        }
                        Button(action: {
                            self.userData.switchActiveCollection()
                        }) {
                            Image(systemName: "arrow.2.squarepath")
                                .padding()
                        }
                    }
                )
            }
            Start()
        }
        .statusBar(hidden: true)
    }
}

struct Home_Previews: PreviewProvider {
    
    static let userData = UserData()
    
    static var previews: some View {
        Home().environmentObject(userData)
    }
}
