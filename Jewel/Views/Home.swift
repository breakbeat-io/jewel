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
    
    private func slotViewForId(slotId: Int) -> some View {
        if userData.slots[slotId].album == nil {
            return AnyView(EmptySlot(slotId: slotId))
        } else {
            return AnyView(FilledSlot(slotId: slotId))
        }
    }
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geo in
                List(self.userData.slots) { slot in
                    self.slotViewForId(slotId: slot.id)
                        .frame(minHeight: 65, idealHeight: (geo.size.height - geo.safeAreaInsets.top - geo.safeAreaInsets.bottom) / CGFloat(self.userData.slots.count))
                }
                .sheet(isPresented: self.$showOptions) {
                    Options().environmentObject(self.userData)
                }
                .onAppear {
                    UITableView.appearance().separatorStyle = .none
                }
                .navigationBarTitle(self.userData.collectionName)
                .navigationBarItems(trailing:
                    Button(action: {
                        self.showOptions = true
                    }) {
                        Image(systemName: "slider.horizontal.3")
                            .padding(.leading)
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
