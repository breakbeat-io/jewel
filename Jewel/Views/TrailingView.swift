//
//  TrailingView.swift
//  Jewel
//
//  Created by Greg Hepworth on 29/05/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import SwiftUI

struct TrailingView: View {
    
    @EnvironmentObject var store: AppStore
    
    var body: some View {
        HStack(alignment: .center, spacing: 30) {
            EditButton()
        }
    }
}

struct TrailingView_Previews: PreviewProvider {
    static var previews: some View {
        TrailingView()
    }
}
