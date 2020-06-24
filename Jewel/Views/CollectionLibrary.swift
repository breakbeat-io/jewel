//
//  CollectionLibrary.swift
//  Listen Later
//
//  Created by Greg Hepworth on 22/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionLibrary: View {
  
  @EnvironmentObject var app: AppEnvironment
  
  
  private var collectionSelected: Binding<Bool> {
    Binding (
      get: { self.app.navigation.selectedCollection != nil },
      set: { _ = $0 }
    )
  }
  private var collections: [Collection] {
    app.state.library.collections
  }
  
  var body: some View {
    VStack(alignment: .leading) {
      Text("Collection Library")
        .font(.title)
        .fontWeight(.bold)
        .padding()
        if collections.isEmpty {
          VStack {
            Spacer()
            Image(systemName: "music.note.list")
              .font(.system(size: 40))
              .padding(.bottom)
            Text("Collections you have saved or that people have shared with you will appear here.")
              .multilineTextAlignment(.center)
            Spacer()
          }
          .padding()
          .foregroundColor(Color.secondary)
        } else {
        List(selection: $app.navigation.libraryEditSelection) {
          ForEach(collections) { collection in
            CollectionCard(collection: collection)
              .sheet(isPresented: self.collectionSelected) {
                CollectionDetail(collection: collection)
                  .environmentObject(self.app)
                  .onDisappear {
                    self.app.navigation.selectedCollection = nil
                }
              }
          }
          .onMove { (indexSet, index) in
            self.app.update(action: LibraryAction.moveSharedCollection(from: indexSet, to: index))
          }
          .onDelete {
            self.app.update(action: LibraryAction.removeSharedCollection(slotIndexes: $0))
          }
        }
        .environment(\.editMode, .constant(self.app.navigation.libraryIsEditing ? EditMode.active : EditMode.inactive))
      }
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
  }
}
