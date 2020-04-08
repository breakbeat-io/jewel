//
//  CircleImage.swift
//  Jewel
//
//  Created by Greg Hepworth on 08/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import SwiftUI
import Grid

struct Releases: Identifiable {
    var id = UUID()
    var title = String()
    var artist = String()
    var artwork = String()
}

struct WalletView: View {
    
    let releases: [Releases] = [
        Releases(title: "All That Must Be", artist: "George Fitzgerald", artwork: "allthatmustbe"),
        Releases(title: "Based On A True Story", artist: "Fat Freddy's Drop", artwork: "basedonatruestory"),
        Releases(title: "Fat Of The Land", artist: "The Prodigy", artwork: "fatoftheland"),
        Releases(title: "Journey Inwards", artist: "LTJ Bukem", artwork: "journeyinwards"),
        Releases(title: "Live At The Social, Volume 1", artist: "Mixed by the Chemical Brothers", artwork: "liveathesocial"),
        Releases(title: "OK Computer", artist: "Radiohead", artwork: "okcomputer"),
        Releases(title: "Psyence Fiction", artist: "UNKLE", artwork: "psyencefiction"),
        Releases(title: "Sincere", artist: "MJ Cole", artwork: "sincere")
    ]
    
    var body: some View {
        NavigationView {
            Grid(releases) { release in
                NavigationLink(
                    destination: ReleaseDetailView (
                        title: release.title,
                        artist: release.artist,
                        artwork: release.artwork
                    )
                ) {
                ReleaseButtonView (
                    title: release.title,
                    artist: release.artist,
                    artwork: release.artwork
                )
                }
            }
            .navigationBarTitle(Text("Wallet"))
            .animation(.easeInOut)
        }
        .gridStyle (
            ModularGridStyle(columns: 2, rows: 4)
        )
    }
}

struct CircleImage_Previews: PreviewProvider {
    static var previews: some View {
        WalletView()
    }
}
