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

  private var showCollection: Binding<Bool> { Binding (
    get: { self.app.state.navigation.showCollection },
    set: { if self.app.state.navigation.showCollection { self.app.update(action: NavigationAction.showCollection($0)) } }
    )}
  
  private var collections: [Collection] {
    app.state.library.collections
  }
  
  var body: some View {
    GeometryReader { geo in
      HStack {
        if self.horizontalSizeClass == .regular {
          Spacer()
        }
        ScrollView {
          Text("Collection Library")
            .font(.title)
            .fontWeight(.bold)
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
            .padding(.top)
          if self.collections.isEmpty {
            VStack {
              Image(systemName: "music.note.list")
                .font(.system(size: 40))
                .padding(.bottom)
              Text("Collections you have saved or that people have shared with you will appear here.")
                .multilineTextAlignment(.center)
            }
            .frame(minWidth: 0, maxWidth: .infinity, alignment: .topLeading)
            .padding()
            .foregroundColor(Color.secondary)
          } else {
            ForEach(self.collections) { collection in
              CollectionCard(collection: collection)
                .frame(height: self.app.state.navigation.collectionCardHeight)
            }
          }
        }
        .padding(.horizontal)
        .frame(maxWidth: self.horizontalSizeClass == .regular ? Constants.regularMaxWidth : .infinity)
        if self.horizontalSizeClass == .regular {
          Spacer()
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .topLeading)
      .sheet(isPresented: self.showCollection) {
        CollectionSheet()
          .environmentObject(self.app)
      }
      .onAppear {
        if geo.size.height != self.app.state.navigation.libraryViewHeight {
          self.app.update(action: NavigationAction.setLibraryViewHeight(viewHeight: geo.size.height))
        }
      }
    }
  }
}
