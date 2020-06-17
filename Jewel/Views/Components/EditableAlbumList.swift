//
//  EditableAlbumList.swift
//  Listen Later
//
//  Created by Greg Hepworth on 17/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct EditableAlbumList: View {
  @EnvironmentObject var environment: AppEnvironment
  
  @State var isEditing = false
  
  var collectionId: UUID
  
  private var collection: Collection? {
    if collectionId == environment.state.library.onRotation.id {
      return environment.state.library.onRotation
    } else {
      if let collectionIndex = environment.state.library.sharedCollections.firstIndex(where: { $0.id == collectionId }) {
        return environment.state.library.sharedCollections[collectionIndex]
      }
    }
    
    return nil
  }
  
  private var slots: [Slot] {
    collection!.slots
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
            } else {
              if collection.type == .userCollection {
                EmptySlotCard(slotIndex: slotIndex, collectionId: self.collectionId)
                  .deleteDisabled(true)
              } else {
                RoundedRectangle(cornerRadius: 4)
                  .fill(Color(UIColor.secondarySystemBackground))
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
        trailing:
        HStack {
          if collection.type == .userCollection {
            Button(action: {
              self.isEditing.toggle()
            }) {
              Text(self.isEditing ? "Done" : "Edit")
            }
          }
        }
      )
        .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
    }
      }
  }
}
