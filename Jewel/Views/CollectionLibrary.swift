//
//  CollectionLibrary.swift
//  Listen Later
//
//  Created by Greg Hepworth on 22/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct CollectionLibrary: View {
  
  @Environment(\.horizontalSizeClass) var horizontalSizeClass
  
  @EnvironmentObject var app: AppEnvironment
  
  private var libraryEditSelection: Binding<Set<UUID>> { Binding (
    get: { self.app.state.navigation.libraryEditSelection },
    set: { self.app.update(action: NavigationAction.setLibraryEditSelection(editSelection: $0))}
  )}
  private var showCollection: Binding<Bool> { Binding (
    get: { self.app.state.navigation.showCollection },
    set: { self.app.update(action: NavigationAction.showCollection($0))}
  )}
  
  private var collections: [Collection] {
    app.state.library.collections
  }
  
  var body: some View {
    HStack {
      if self.horizontalSizeClass == .regular {
        Spacer()
      }
      List(selection: libraryEditSelection) {
        Text("Collection Library")
          .font(.title)
          .fontWeight(.bold)
          .padding(.top)
        if self.collections.isEmpty {
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
          ForEach(self.collections) { collection in
            CollectionCard(collection: collection)
              .frame(height: self.app.state.navigation.cardHeight)
          }
          .onMove { (indexSet, index) in
            self.app.update(action: LibraryAction.moveSharedCollection(from: indexSet, to: index))
          }
          .onDelete {
            self.app.update(action: LibraryAction.removeSharedCollection(slotIndexes: $0))
          }
        }
      }
      .environment(\.editMode, .constant(self.app.state.navigation.libraryIsEditing ? EditMode.active : EditMode.inactive))
      .frame(maxWidth: self.horizontalSizeClass == .regular ? Constants.regularMaxWidth : .infinity)
      if self.horizontalSizeClass == .regular {
        Spacer()
      }
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
    .sheet(isPresented: showCollection) {
      CollectionSheet()
        .environmentObject(self.app)
    }
  }
}
