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

  private var showSheet: Binding<Bool> { Binding (
    get: { self.app.state.navigation.showSourceDetail || self.app.state.navigation.showSearch },
    set: {
      if self.app.state.navigation.showSourceDetail { self.app.update(action: NavigationAction.showSourceDetail($0)) }
      if self.app.state.navigation.showSearch { self.app.update(action: NavigationAction.showSearch($0)) }
  }
    )}
  private var slots: [Slot] {
    collection.slots
  }
  private var editable: Bool {
    collection.type == .userCollection ? true : false
  }
  private var collectionEmpty: Bool {
    collection.slots.filter( { $0.source != nil }).count == 0
  }
  
  var body: some View {
    GeometryReader { geo in
      HStack {
        if self.horizontalSizeClass == .regular {
          Spacer()
        }
        ScrollView {
          VStack(alignment: .leading) {
            Text(self.collection.name)
              .font(.title)
              .fontWeight(.bold)
              .padding(.top)
            Text("by \(self.collection.curator)")
              .font(.subheadline)
              .fontWeight(.light)
              .foregroundColor(.secondary)
          }
          .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
          ForEach(self.slots.indices, id: \.self) { slotIndex in
            Group {
              if self.slots[slotIndex].source != nil {
                IfLet(self.slots[slotIndex].source) { album in
                  Button {
                    self.app.update(action: NavigationAction.setActiveSlotIndex(slotIndex: slotIndex))
                    self.app.update(action: NavigationAction.showSourceDetail(true))
                  } label: {
                    SourceCard(sourceName: album.title, sourceArtist: album.artistName, sourceArtwork: album.artwork?.url(width: 1000, height: 1000))
                  }
                }
              } else if self.editable {
                AddSourceCardButton(slotIndex: slotIndex, collectionId: self.collection.id)
              } else {
                RoundedRectangle(cornerRadius: Constants.cardCornerRadius)
                  .fill(Color(UIColor.secondarySystemBackground))
              }
            }
            .frame(height: self.app.state.navigation.albumCardHeight)
          }
        }
        .padding(.horizontal)
        .frame(maxWidth: self.horizontalSizeClass == .regular && !self.app.state.navigation.showCollection ? Constants.regularMaxWidth : .infinity)
        if self.horizontalSizeClass == .regular {
          Spacer()
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
      .sheet(isPresented: self.showSheet) {
        if self.app.state.navigation.showSourceDetail {
          AlbumDetail()
            .environmentObject(self.app)
        } else if self.app.state.navigation.showSearch {
          SearchHome()
            .environmentObject(self.app)
        }
      }
      .onAppear {
        if geo.size.height != self.app.state.navigation.collectionViewHeight {
          self.app.update(action: NavigationAction.setCollectionViewHeight(viewHeight: geo.size.height))
        }
      }
      .onDisappear {
        if !self.app.state.navigation.onRotationActive && self.collectionEmpty {
          self.app.update(action: NavigationAction.setActiveCollectionId(collectionId: self.app.state.navigation.onRotationId!))
          self.app.update(action: LibraryAction.removeCollection(collectionId: self.collection.id))
        }
      }
    }
  }
}
