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
  
  var collection: Collection
  
  private var slots: [Slot] {
    collection.slots
  }
  private var editable: Bool {
    collection.type == .userCollection ? true : false
  }
  
  var body: some View {
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
                    SourceCard(sourceName: attributes.name, sourceArtist: attributes.artistName, sourceArtwork: attributes.artwork.url(forWidth: 1000))
                      .sheet(isPresented: self.$app.navigation.showSourceDetail) {
                        AlbumDetail(slot: self.slots[slotIndex])
                      }
                  }
                } else if self.editable {
                  AddSourceCard(slotIndex: slotIndex, collectionId: self.collection.id)
                } else {
                  RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                    .fill(Color(UIColor.secondarySystemBackground))
                }
              }
              .deleteDisabled(!self.editable)
              .frame(height: Constants.cardHeightFor(viewHeight: geo.size.height))
            }
            .onMove { (indexSet, index) in
              self.app.update(action: LibraryAction.moveSlot(from: indexSet, to: index, collectionId: self.collection.id))
            }
            .onDelete {
              self.app.update(action: LibraryAction.removeAlbumFromSlot(slotIndexes: $0, collectionId: self.collection.id))
            }
          }
          .environment(\.editMode, .constant(self.app.navigation.collectionIsEditing ? EditMode.active : EditMode.inactive))
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
  }
}