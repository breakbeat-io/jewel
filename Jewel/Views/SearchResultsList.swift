//
//  SearchResultsList.swift
//  Jewel
//
//  Created by Greg Hepworth on 24/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import SDWebImageSwiftUI

struct SearchResultsList: View {
    var body: some View {
        List(0...6, id: \.self) { _ in
            HStack {
                VStack(alignment: .leading) {
                    Text("The Fat Of The Land")
                        .font(.headline)
                    Text("The Prodigy")
                        .font(.subheadline)
                }
                Spacer()
                WebImage(url: URL(string: "https://via.placeholder.com/50"))
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipped()
                    .clipShape(RoundedRectangle(cornerRadius: 4))
                    .frame(width: 50)
            }
        }
    }
}

struct SearchResultsList_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsList()
    }
}
