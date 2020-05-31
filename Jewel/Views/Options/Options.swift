//
//  Options.swift
//  Jewel
//
//  Created by Greg Hepworth on 31/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct Options: View {
    
    @EnvironmentObject private var store: AppStore
    
    @Binding var showing: Bool
    
    @State var collectionName: String = ""
    @State var collectionCurator: String = ""
    
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(footer: Text("Choose a name for your collection, and to represent the curator when sharing the collection.")) {
                        HStack(alignment: .firstTextBaseline) {
                            Text("Collection Name")
                            TextField(
                                store.state.collection.name,
                                text: $collectionName,
                                onCommit: {
                                    self.store.update(action: CollectionAction.changeCollectionName(name: self.collectionName))
                                    self.showing = false
                            }
                            ).foregroundColor(.accentColor)
                        }
                        HStack(alignment: .firstTextBaseline) {
                            Text("Curator")
                            TextField(
                                store.state.collection.curator,
                                text: $collectionCurator,
                                onCommit: {
                                    self.store.update(action: CollectionAction.changeCollectionCurator(curator: self.collectionCurator))
                                    self.showing = false
                            }
                            ).foregroundColor(.accentColor)
                        }
                    }
                }
                Spacer()
                Footer()
                    .padding()
            }
            .navigationBarTitle("Options", displayMode: .inline)
            .navigationBarItems(trailing:
                Button(action: {
                    self.showing = false
                }) {
                    Text("Close")
                }
            )
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
