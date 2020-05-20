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
    @EnvironmentObject var userData: UserData
    
    @State private var showOptions = false
    @State private var showShareSheet = false
    
    var body: some View {
        
        NavigationView {
            GeometryReader { geo in
                List(self.userData.activeCollection.slots.indices, id: \.self) { index in
                    Group {
                        if self.userData.activeCollection.slots[index].source?.content == nil {
                            EmptySlot(slotIndex: index)
                        } else {
                            FilledSlot(slotIndex: index)
                        }
                    }
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
                    }
                    .padding(.trailing)
                    .padding(.vertical)
                    ,trailing:
                    HStack {
                        Button(action: {
                            self.showShareSheet = true
                        }) {
                            Image(systemName: "square.and.arrow.up")
                        }
                        .padding(.leading)
                        .padding(.vertical)
                        .disabled(self.userData.activeCollection.slots.filter( { $0.source != nil }).count == 0)
                        .sheet(isPresented: self.$showShareSheet) {
                            ShareSheet(activityItems: [self.userData.createShareUrl()])
                        }
                        Button(action: {
                            self.userData.userCollectionActive.toggle()
                        }) {
                            Image(systemName: "arrow.2.squarepath")
                        }
                        .padding(.leading)
                        .padding(.vertical)
                        .disabled(self.userData.sharedCollection.slots.filter( { $0.source != nil }).count == 0)
                    }
                )
            }
            .alert(isPresented: $userData.sharedCollectionCued) {
                Alert(title: Text("Shared collection received from \(userData.candidateCollection?.curator ?? "a discerning curator")!"),
                      message: Text("Would you like to replace your current shared collection?"),
                      primaryButton: .cancel(Text("Cancel")),
                      secondaryButton: .default(Text("Replace").bold()) {
                        self.userData.loadCandidateCollection()
                        self.presentationMode.wrappedValue.dismiss()
                    })
            }
            Start()
        }
        .statusBar(hidden: true)
    }
}
