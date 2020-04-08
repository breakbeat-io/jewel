//
//  CircleImage.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct Page: View {
    var body: some View {
        GeometryReader { geo in
            VStack {
                HStack {
                    Album()
                        .frame(width: geo.size.width/2)
                    Album()
                        .frame(width: geo.size.width/2)
                }
                .frame(height: geo.size.height/4)
                HStack {
                 Album()
                     .frame(width: geo.size.width/2)
                 Album()
                     .frame(width: geo.size.width/2)
             }
             .frame(height: geo.size.height/4)
                HStack {
                                 Circle()
                                     .frame(width: geo.size.width/2)
                                 Circle()
                                     .frame(width: geo.size.width/2)
                             }
                             .frame(height: geo.size.height/4)
                HStack {
                                 Circle()
                                     .frame(width: geo.size.width/2)
                                 Circle()
                                     .frame(width: geo.size.width/2)
                             }
                             .frame(height: geo.size.height/4)
            }
        }
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        Page()
    }
}
