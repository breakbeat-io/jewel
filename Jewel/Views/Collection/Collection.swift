//
//  Home.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct Collection: View {
  
  @EnvironmentObject var store: AppStore
  
  private var slots: [Slot] {
    store.state.collection.slots
  }
  
  var body: some View {
    GeometryReader { geo in
      List {
        ForEach(self.slots.indices, id: \.self) { slotIndex in
          Group {
            if self.slots[slotIndex].album != nil {
              ZStack {
                FilledSlot(slotIndex: slotIndex)
                NavigationLink(
                  destination: AlbumDetail()
                ){
                  EmptyView()
                }
              }
            } else {
              EmptySlot(slotIndex: slotIndex)
                .deleteDisabled(true)
            }
          }
          .frame(height: (geo.size.height - geo.safeAreaInsets.top - geo.safeAreaInsets.bottom) / CGFloat(self.slots.count))
        }
        .onMove { (indexSet, index) in
          self.store.update(action: CollectionAction.moveSlot(from: indexSet, to: index))
        }
        .onDelete {
          self.store.update(action: CollectionAction.removeAlbumFromSlot(slotIndexes: $0))
        }
      }
      .onAppear {
        UITableView.appearance().separatorStyle = .none
      }
      .navigationBarTitle(self.store.state.collection.name)
      .navigationBarItems(
        leading: CollectionNavigationButtonsLeading(),
        trailing: CollectionNavigationButtonsTrailing()
      )
    }
  }
}

struct CollectionNavigationButtonsLeading: View {
  
  @EnvironmentObject var store: AppStore
  
  @State private var showOptions: Bool = false
  @State private var showSharing: Bool = false
  
  var body: some View {
    HStack {
      Button(action: {
        self.showSharing = true
      }) {
        Image(systemName: "square.and.arrow.up")
      }
      .padding(.trailing)
      .actionSheet(isPresented: $showSharing) {
        ActionSheet(title: Text("Share Collection"),
                    buttons: [
                      .default(Text("Add to Library")) {
                        self.store.update(action: LibraryAction.addCollection(collection: self.store.state.collection))
                        self.store.update(action: CollectionAction.toggleActive)
                      },
                      .cancel()
                    ])
      }
      Button(action: {
        self.showOptions = true
      }) {
        Image(systemName: "slider.horizontal.3")
      }
      .padding(.trailing)
      .sheet(isPresented: self.$showOptions) {
        Options(showing: self.$showOptions)
          .environmentObject(self.store)
      }
    }
    .padding(.vertical)
  }
}

struct CollectionNavigationButtonsTrailing: View {
  
  @EnvironmentObject var store: AppStore
  
  var body: some View {
    HStack {
      EditButton()
        .padding(.leading)
      Button(action: {
        self.store.update(action: CollectionAction.toggleActive)
      }) {
        Image(systemName: "square.stack" )
      }
      .padding(.leading)
    }
    .padding(.vertical)
  }
}
