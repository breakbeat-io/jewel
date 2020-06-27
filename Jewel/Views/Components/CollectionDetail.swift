//
//  EditableAlbumList.swift
//  Listen Later
//
//  Created by Greg Hepworth on 17/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionDetail: View {
  
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
  @EnvironmentObject var app: AppEnvironment
  
  var collection: Collection
  
  private var slots: [Slot] {
    collection.slots
  }
  private var editable: Bool {
    collection.type == .userCollection ? true : false
  }
  
  var body: some View {
    HStack {
      if horizontalSizeClass == .regular {
        Spacer()
      }
      GeometryReader { geo in
        List(selection: self.$app.navigation.collectionEditSelection) {
          VStack(alignment: .leading) {
            Text(self.collection.name)
              .font(.title)
              .fontWeight(.bold)
              .padding(.top)
            Text("by \(self.collection.curator)")
              .font(.subheadline)
              .fontWeight(.light)
              .foregroundColor(.secondary)
            ForEach(self.slots.indices, id: \.self) { slotIndex in
              Group {
                if self.slots[slotIndex].source != nil {
                  IfLet(self.slots[slotIndex].source?.attributes) { attributes in
                    Button(action: {
                      self.app.navigation.activeSlotIndex = slotIndex
                      self.app.navigation.showSourceDetail = true
                    }) {
                      SourceCard(sourceName: attributes.name, sourceArtist: attributes.artistName, sourceArtwork: attributes.artwork.url(forWidth: 1000))
                    }
                  }
                } else if self.editable {
                  AddSourceCardButton(slotIndex: slotIndex, collectionId: self.collection.id)
                    .deleteDisabled(true)
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
              self.app.update(action: LibraryAction.removeSourceFromSlot(slotIndexes: $0, collectionId: self.collection.id))
            }
          }
          .environment(\.editMode, .constant(self.app.navigation.collectionIsEditing ? EditMode.active : EditMode.inactive))
        }
      }
      .frame(maxWidth: horizontalSizeClass == .regular && !app.navigation.showCollection ? Constants.regularMaxWidth : .infinity)
      if horizontalSizeClass == .regular {
        Spacer()
      }
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    .sheet(isPresented: self.$app.navigation.showSourceDetail) {
      AlbumDetail()
        .environmentObject(self.app)
    }
  }
}
