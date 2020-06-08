//
//  Home.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI
import HMV

struct UserCollection: View {
  
  @EnvironmentObject var store: AppStore
  
  private var slots: [Slot] {
    store.state.library.userCollection.slots
  }
  
  var body: some View {
    GeometryReader { geo in
      List {
        ForEach(self.slots.indices, id: \.self) { slotIndex in
          Group {
            if self.slots[slotIndex].album != nil {
              ZStack {
                IfLet(self.slots[slotIndex].album?.attributes) { attributes in
                  AlbumCard(albumName: attributes.name, albumArtist: attributes.artistName, albumArtwork: attributes.artwork.url(forWidth: 1000))
                }
                NavigationLink(
                  destination: ObservedAlbumDetail(slotId: slotIndex)
                ){
                  EmptyView()
                }
              }
            } else {
              EmptySlotCard(slotIndex: slotIndex)
                .deleteDisabled(true)
            }
          }
          .frame(height: (geo.size.height - geo.safeAreaInsets.top - geo.safeAreaInsets.bottom) / CGFloat(self.slots.count))
        }
        .onMove { (indexSet, index) in
          self.store.update(action: LibraryAction.moveSlot(from: indexSet, to: index))
        }
        .onDelete {
          self.store.update(action: LibraryAction.removeAlbumFromSlot(slotIndexes: $0))
        }
      }
      .onAppear {
        UITableView.appearance().separatorStyle = .none
      }
      .navigationBarTitle(self.store.state.library.userCollection.name)
      .navigationBarItems(
        leading: CollectionNavigationButtonsLeading(),
        trailing: NavigationBarItemsTrailing()
      )
    }
  }
}

struct CollectionNavigationButtonsLeading: View {
  
  @EnvironmentObject var store: AppStore
  
  @State private var showOptions: Bool = false
  @State private var showSharing: Bool = false
  @State private var showShareLink: Bool = false
  
  private var collectionEmpty: Bool {
    store.state.library.userCollection.slots.filter( { $0.album != nil }).count == 0
  }
  
  var body: some View {
    HStack {
      Button(action: {
        self.showSharing = true
      }) {
        Image(systemName: "square.and.arrow.up")
      }
      .padding(.trailing)
      .disabled(collectionEmpty)
      .actionSheet(isPresented: $showSharing) {
        ActionSheet(
          title: Text("Share this collection as \n \"\(store.state.library.userCollection.name)\" by \"\(store.state.library.userCollection.curator)\""),
          buttons: [
            .default(Text("Send share link")) {
              self.showShareLink = true
            },
            .default(Text("Add to my Collection Library")) {
              self.store.update(action: LibraryAction.addSharedCollection(collection: self.store.state.library.userCollection))
              self.store.update(action: LibraryAction.setActiveState(activeState: false))
            },
            .default(Text("Update Collection Name")) {
              self.showOptions = true
            },
            .cancel()
        ])
      }
      .sheet(isPresented: self.$showShareLink) {
        ShareSheetLoader()
          .environmentObject(self.store)
      }
      Button(action: {
        self.showOptions = true
      }) {
        Image(systemName: "slider.horizontal.3")
      }
      .padding(.trailing)
      .sheet(isPresented: self.$showOptions) {
        OptionsHome(showing: self.$showOptions)
          .environmentObject(self.store)
      }
    }
    .padding(.vertical)
  }
}
