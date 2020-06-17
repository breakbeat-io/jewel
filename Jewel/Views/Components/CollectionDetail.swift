//
//  EditableAlbumList.swift
//  Listen Later
//
//  Created by Greg Hepworth on 17/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionDetail: View {
  @EnvironmentObject var environment: AppEnvironment
  
  var collectionId: UUID
  
  private var collection: Collection? {
    if collectionId == environment.state.library.onRotation.id {
      return environment.state.library.onRotation
    } else {
      if let collectionIndex = environment.state.library.collections.firstIndex(where: { $0.id == collectionId }) {
        return environment.state.library.collections[collectionIndex]
      }
    }
    
    return nil
  }
  
  private var slots: [Slot] {
    collection!.slots
  }
  private var editable: Bool {
    collection?.type == .userCollection ? true : false
  }
  private var empty: Bool {
    slots.filter({ $0.album != nil }).count == 0
  }
  
  var body: some View {
    GeometryReader { geo in
      IfLet(self.collection) { collection in
        List {
          ForEach(self.slots.indices, id: \.self) { slotIndex in
            Group {
              if self.slots[slotIndex].album != nil {
                ZStack {
                  IfLet(self.slots[slotIndex].album?.attributes) { attributes in
                    AlbumCard(albumName: attributes.name, albumArtist: attributes.artistName, albumArtwork: attributes.artwork.url(forWidth: 1000))
                  }
                  NavigationLink(
                    destination: ObservedAlbumDetail(slotId: slotIndex, collectionId: self.collectionId)
                  ){
                    EmptyView()
                  }
                }
                .deleteDisabled(!self.editable)
              } else {
                if self.editable {
                  EmptySlotCard(slotIndex: slotIndex, collectionId: self.collectionId)
                    .deleteDisabled(true)
                } else {
                  RoundedRectangle(cornerRadius: 4)
                    .fill(Color(UIColor.secondarySystemBackground))
                    .deleteDisabled(true)
                }
              }
            }
            .frame(height: Helpers.cardHeightFor(viewHeight: geo.size.height)
            )
          }
          .onMove { (indexSet, index) in
            self.environment.update(action: LibraryAction.moveSlot(from: indexSet, to: index, collectionId: self.collectionId))
          }
          .onDelete {
            self.environment.update(action: LibraryAction.removeAlbumFromSlot(slotIndexes: $0, collectionId: self.collectionId))
          }
        }
        .navigationBarTitle(collection.name)
        .navigationBarItems(
          leading: UserCollectionButtons(collectionId: self.collectionId).environmentObject(self.environment),
          trailing: self.editable && !self.empty ? AnyView(EditButton()) : AnyView(EmptyView())
        )
      }
    }
  }
}
