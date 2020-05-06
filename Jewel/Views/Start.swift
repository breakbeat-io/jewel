//
//  Start.swift
//  Jewel
//
//  Created by Greg Hepworth on 06/05/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct Start: View {
    
    var body: some View {
        VStack {
            Spacer()
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(width: 200, height: 200)
                .cornerRadius(20)
                .shadow(radius: 20)
            Text("Jewel")
                .font(.largeTitle)
            Text("Listen Later for Apple Music")
                .font(.headline)
            Spacer()
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "sidebar.left")
                Text("Manage your collection in the sidebar")
            }.padding()
        }
    }
}

struct Start_Previews: PreviewProvider {
    static var previews: some View {
        Start()
    }
}
