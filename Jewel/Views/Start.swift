//
//  Start.swift
//  Jewel
//
//  Created by Greg Hepworth on 06/05/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct Start: View {
    
    @State private var fadeIn = false
    
    var body: some View {
        VStack {
            Spacer()
            Image("logo")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 150)
                .cornerRadius(20)
                .shadow(radius: 20)
            Text("Jewel")
                .font(.largeTitle)
            Text("Listen Later for Apple Music")
                .font(.headline)
            Spacer()
            HStack(alignment: .firstTextBaseline) {
                Image(systemName: "chevron.left.2")
                Image(systemName: "sidebar.left")
                Text("Manage your collection from the sidebar")
            }
            .foregroundColor(.secondary)
            .padding()
        }
        .opacity(fadeIn ? 1 : 0)
        .animation(Animation.easeIn(duration: 2))
        .onAppear {
            self.fadeIn = true
        }
    }
}

struct Start_Previews: PreviewProvider {
    static var previews: some View {
        Start()
    }
}
