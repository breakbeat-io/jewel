//
//  DataSource.swift
//  Jewel
//
//  Created by Greg Hepworth on 16/04/2020.
//  Copyright © 2020 Breakbeat Limited. All rights reserved.
//

import HMV

var releasesData = load()
let store = HMV()

func load() -> [Release] {
    var releasesData = [Release]()
    
    releasesData.append(store.getRelease(releaseId: 1001))
    releasesData.append(store.getRelease(releaseId: 1002))
    releasesData.append(store.getRelease(releaseId: 1003))
    releasesData.append(store.getRelease(releaseId: 1004))
    releasesData.append(store.getRelease(releaseId: 1005))
    releasesData.append(store.getRelease(releaseId: 1006))
    releasesData.append(store.getRelease(releaseId: 1007))
    releasesData.append(store.getRelease(releaseId: 1008))
    
    return releasesData
}
