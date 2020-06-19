//
//  EditableAlbumList.swift
//  Listen Later
//
//  Created by Greg Hepworth on 17/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionDetail: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  var collectionId: UUID
  
  private var collection: Collection? {
    if collectionId == app.state.library.onRotation.id {
      return app.state.library.onRotation
    } else if let collectionIndex = app.state.library.collections.firstIndex(where: { $0.id == collectionId }) {
      return app.state.library.collections[collectionIndex]
    }
    return nil
  }
  
  private var slots: [Slot] {
    collection!.slots
  }
  private var editable: Bool {
    collection!.type == .userCollection ? true : false
  }
  
  var body: some View {
    GeometryReader { geo in
      IfLet(self.collection) { collection in
        List(selection: self.$app.navigation.collectionEditSelection) {
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
                Group {
                  if self.editable {
                    EmptySlotCard(slotIndex: slotIndex, collectionId: self.collectionId)
                  } else {
                    RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                      .fill(Color(UIColor.secondarySystemBackground))
                  }
                }
                .deleteDisabled(true)
              }
            }
            .frame(height: Constants.cardHeightFor(viewHeight: geo.size.height)
            )
          }
          .onMove { (indexSet, index) in
            self.app.update(action: LibraryAction.moveSlot(from: indexSet, to: index, collectionId: self.collectionId))
          }
          .onDelete {
            self.app.update(action: LibraryAction.removeAlbumFromSlot(slotIndexes: $0, collectionId: self.collectionId))
          }
        }
        .environment(\.editMode, .constant(self.app.navigation.collectionIsEditing ? EditMode.active : EditMode.inactive)).animation(Animation.spring())
        .navigationBarTitle(collection.name)
        .navigationBarItems(
          leading:
            CollectionEditButtons(collectionId: self.collectionId)
              .padding(.vertical)
              .environmentObject(self.app),
          trailing:
            CollectionOptionsButton(collectionId: self.collectionId)
              .disabled(self.app.navigation.collectionIsEditing)
              .padding([.vertical, .leading])
              .environmentObject(self.app)
        )
      }
    }
  }
}
