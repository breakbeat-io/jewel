//
//  ItemListView.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct ItemListView: View {
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        List {
            ForEach(store.state.collection.albums) { album in
                Text("This will be an Album")
            }
            .onDelete {
                self.store.update(action: CollectionActions.removeAlbum(at: $0))
            }
        }
    }
}

struct ItemListView_Previews: PreviewProvider {
    static var previews: some View {
        ItemListView()
    }
}
