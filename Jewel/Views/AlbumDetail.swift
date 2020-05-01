//
//  ReleaseDetailView.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import KingfisherSwiftUI
import HMV

struct AlbumDetail: View {
    
    @EnvironmentObject var wallet: SlotStore
    var slotId: Int
    
    var body: some View {
        ScrollView {
            VStack {
                VStack(alignment: .leading) {
                    Unwrap(wallet.slots[slotId].album?.attributes) { attributes in
                        KFImage(attributes.artwork.url(forWidth: 1000))
                            .placeholder {
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray)
                            }
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(4)
                            .shadow(radius: 4)
                        Text(attributes.name)
                            .fontWeight(.bold)
                            .font(.title)
                            .foregroundColor(.black)
                            .lineLimit(1)
                        Text(attributes.artistName)
                            .font(.title)
                            .foregroundColor(.black)
                            .lineLimit(1)
                    }
                }
                if (wallet.slots[slotId].album?.attributes?.url != nil) {
                    HStack(alignment: .center) {
                        PlaybackControls(slotId: slotId)
                        .padding()
                    }
                }
                if (wallet.slots[slotId].album != nil) {
                    AlbumTrackList(slotId: slotId)
                }
            }
            .padding()
        }
        .background(
            Unwrap(wallet.slots[slotId].album?.attributes?.artwork) { artwork in
                KFImage(artwork.url(forWidth: 1000))
                .resizable()
                .scaledToFill()
                .brightness(0.4)
                .blur(radius: 20)
                .edgesIgnoringSafeArea(.all)
            }
        )
        .navigationBarItems(trailing:
            Button(action: {
                self.wallet.deleteAlbumFromSlot(slotId: self.slotId)
            }) {
                if (wallet.slots[slotId].album != nil) {
                    Image(systemName: "trash")
                        .padding()
                        .foregroundColor(.red)
                    }
            }
        )
    }
}

struct ReleaseDetail_Previews: PreviewProvider {
    static let wallet = SlotStore()
    
    static var previews: some View {
        AlbumDetail(slotId: 0)
    }
}
