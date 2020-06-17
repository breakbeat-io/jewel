//
//  Library.swift
//  Listen Later
//
//  Created by Greg Hepworth on 04/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionLibrary: View {
  
  @EnvironmentObject var environment: AppEnvironment
  
  @Binding var isEditing: Bool
  
  private var collections: [Collection] {
    environment.state.library.sharedCollections
  }
  
  var body: some View {
    Group {
      if collections.count == 0 {
        Text("Collections you have saved or that people have shared with you will appear here.")
          .multilineTextAlignment(.center)
          .foregroundColor(Color.secondary)
          .padding()
      } else {
        List {
          ForEach(collections) { collection in
            NavigationLink(destination: EditableAlbumList(collection: collection)) {
              CollectionCard(collection: collection)
            }
          }
          .onMove { (indexSet, index) in
            self.environment.update(action: LibraryAction.moveSharedCollection(from: indexSet, to: index))
          }
          .onDelete {
            self.environment.update(action: LibraryAction.removeSharedCollection(slotIndexes: $0))
          }
        }
        .environment(\.editMode, .constant(self.isEditing ? EditMode.active : EditMode.inactive))
      }
    }
    .onAppear {
      self.isEditing = false
    }
  }
}
