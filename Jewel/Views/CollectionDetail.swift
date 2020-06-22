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
    if let collectionIndex = app.state.library.collections.firstIndex(where: { $0.id == collectionId }) {
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
    IfLet(collection) { collection in
      VStack(alignment: .leading) {
        VStack(alignment: .leading) {
          Text(collection.name)
            .font(.title)
            .fontWeight(.bold)
          Text("by \(collection.curator)")
            .font(.subheadline)
            .fontWeight(.light)
            .foregroundColor(.secondary)
        }
        .padding()
        GeometryReader { geo in
          List(selection: self.$app.navigation.collectionEditSelection) {
            ForEach(self.slots.indices, id: \.self) { slotIndex in
              Group {
                if self.slots[slotIndex].album != nil {
                  IfLet(self.slots[slotIndex].album?.attributes) { attributes in
                    SourceCard(slot: self.slots[slotIndex], sourceName: attributes.name, sourceArtist: attributes.artistName, sourceArtwork: attributes.artwork.url(forWidth: 1000))
                  }
                } else if self.editable {
                  AddSourceCard(slotIndex: slotIndex, collectionId: collection.id)
                } else {
                  RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                    .fill(Color(UIColor.secondarySystemBackground))
                }
              }
              .deleteDisabled(!self.editable)
              .frame(height: Constants.cardHeightFor(viewHeight: geo.size.height))
            }
            .onMove { (indexSet, index) in
              self.app.update(action: LibraryAction.moveSlot(from: indexSet, to: index, collectionId: collection.id))
            }
            .onDelete {
              self.app.update(action: LibraryAction.removeAlbumFromSlot(slotIndexes: $0, collectionId: collection.id))
            }
          }
          .environment(\.editMode, .constant(self.app.navigation.collectionIsEditing ? EditMode.active : EditMode.inactive))
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    }
  }
}
