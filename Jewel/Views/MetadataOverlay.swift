//
//  ReleaseMetadataOverlayView.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI

struct MetadataOverlay: View {
    
    @EnvironmentObject var wallet: UserData
    var slotId: Int
    
    var body: some View {
        VStack(alignment: .leading) {
            Unwrap(wallet.slots[slotId].album?.attributes) { attributes in
                Text(attributes.name)
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 4)
                    .padding(.horizontal, 6)
                    .lineLimit(1)
                Text(attributes.artistName)
                    .font(.footnote)
                    .foregroundColor(.white)
                    .padding(.horizontal, 6)
                    .padding(.bottom, 4)
                    .lineLimit(1)
            }
        }
        .background(Color.black)
        .cornerRadius(2.0)
        .padding(4)
    }
}

struct ReleaseMetadataOverlay_Previews: PreviewProvider {
    static var previews: some View {
        MetadataOverlay(slotId: 0)
    }
}
