//
//  LibraryActions.swift
//  Listen Later
//
//  Created by Greg Hepworth on 03/07/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

func updateLibrary(library: Library, action: LibraryAction) -> Library {
  
  func extractCollection(collectionId: UUID) -> Collection? {
    if newLibrary.onRotation.id == collectionId {
      return newLibrary.onRotation
    } else if let collectionIndex = newLibrary.collections.firstIndex(where: { $0.id == collectionId }) {
      return newLibrary.collections[collectionIndex]
    }
    return nil
  }
  
  func commitCollection(collection: Collection) {
    if collection.id == newLibrary.onRotation.id {
      newLibrary.onRotation = collection
    } else if let collectionIndex = newLibrary.collections.firstIndex(where: { $0.id == collection.id }) {
      newLibrary.collections[collectionIndex] = collection
    }
  }
  
  var newLibrary = library
  
  switch action {
    
  case let .setCollectionName(name, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      collection.name = name
      commitCollection(collection: collection)
    }
    
  case let .setCollectionCurator(curator, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      collection.curator = curator
      commitCollection(collection: collection)
    }
    
  case let .addSourceToSlot(source, slotIndex, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      collection.slots[slotIndex].source = source
      commitCollection(collection: collection)
    }
    
  case let .removeSourceFromSlot(slotIndex, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      collection.slots[slotIndex] = Slot()
      commitCollection(collection: collection)
    }
    
  case let .removeSourcesFromCollection(slotIndexes, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      for slotIndex in slotIndexes {
        collection.slots[slotIndex] = Slot()
      }
      commitCollection(collection: collection)
    }
    
  case let .moveSlot(from, to, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      collection.slots.move(fromOffsets: IndexSet([from]), toOffset: to)
      commitCollection(collection: collection)
    }
    
  case let .invalidateShareLinks(collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      collection.shareLinkLong = nil
      collection.shareLinkShort = nil
      commitCollection(collection: collection)
    }
    
  case let .setShareLinks(shareLinkLong, shareLinkShort, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      collection.shareLinkLong = shareLinkLong
      collection.shareLinkShort = shareLinkShort
      commitCollection(collection: collection)
    }
    
  case let .saveOnRotation(collection):
    let formatter = DateFormatter()
    formatter.dateFormat = "MMM yyyy"
    let dateString = formatter.string(from: Date())
    var newCollection = collection
    newCollection.id = UUID()
    newCollection.name = "My \(Navigation.Tab.onRotation.rawValue) — \(dateString)"
    newLibrary.collections.insert(newCollection, at: 0)
    
  case .createCollection:
    let newCollection = Collection(type: .userCollection, name: "New Collection", curator: newLibrary.onRotation.curator)
    newLibrary.collections.insert(newCollection, at: 0)
    
  case let .addCollection(collection):
    newLibrary.collections.insert(collection, at: 0)
    
  case let .copyCollection(collectionId):
    print("Copying collection placeholder")
    
  case let .removeCollection(slotIndex):
    newLibrary.collections.remove(at: slotIndex)
    
  case let .removeCollections(collectionIds):
    for collectionId in collectionIds {
      newLibrary.collections.removeAll(where: { $0.id == collectionId} )
    }
    
  case let .moveCollection(from, to):
    newLibrary.collections.move(fromOffsets: IndexSet([from]), toOffset: to)
    
  case let .cueSharedCollection(shareableCollection):
    newLibrary.cuedCollection = shareableCollection
    
  case .uncueSharedCollection:
    newLibrary.cuedCollection = nil
    
  case let .setPlatformLinks(baseUrl, platformLinks, collectionId):
    if var collection = extractCollection(collectionId: collectionId) {
      let indices = collection.slots.enumerated().compactMap({ $1.source?.attributes?.url == baseUrl ? $0 : nil })
      for i in indices {
        collection.slots[i].playbackLinks = platformLinks
      }
      commitCollection(collection: collection)
    }
    
  }
  
  return newLibrary
  
}

enum LibraryAction: AppAction {
  
  case setCollectionName(name: String, collectionId: UUID)
  case setCollectionCurator(curator: String, collectionId: UUID)
  case addSourceToSlot(source: AppleMusicAlbum, slotIndex: Int, collectionId: UUID)
  case removeSourceFromSlot(slotIndex: Int, collectionId: UUID)
  case removeSourcesFromCollection(slotIndexes: Set<Int>, collectionId: UUID)
  case setPlatformLinks(baseUrl: URL, platformLinks: OdesliResponse, collectionId: UUID)
  case moveSlot(from: Int, to: Int, collectionId: UUID)
  case invalidateShareLinks(collectionId: UUID)
  case setShareLinks(shareLinkLong: URL, shareLinkShort: URL, collectionId: UUID)
  case saveOnRotation(collection: Collection)
  case createCollection
  case addCollection(collection: Collection)
  case copyCollection(collectionId: UUID)
  case removeCollection(libraryIndex: Int)
  case removeCollections(collectionIds: Set<UUID>)
  case moveCollection(from: Int, to: Int)
  case cueSharedCollection(shareableCollection: SharedCollectionManager.ShareableCollection)
  case uncueSharedCollection
  
  var description: String {
    switch self {
      
    case .setCollectionName(let name, _):
      return "\(type(of: self)): Setting user collection name to \(name)"
      
    case .setCollectionCurator(let curator, _):
      return "\(type(of: self)): Setting user collection curator to \(curator)"
      
    case .addSourceToSlot(let source, let slotIndex, let collectionId):
      return "\(type(of: self)): Adding AppleMusicAlbum \(source.id) to slot \(slotIndex) in collection \(collectionId)"
      
    case .removeSourceFromSlot(let slotIndex, let collectionId):
      return "\(type(of: self)): Removing source in slot \(slotIndex) from collection \(collectionId)"
      
    case .removeSourcesFromCollection(let slotIndexes, let collectionId):
      return "\(type(of: self)): Removing sources in slots \(slotIndexes) from collection \(collectionId)"
      
    case .setPlatformLinks(let baseUrl, _, let collectionId):
      return "\(type(of: self)): Setting platform links for any source with \(baseUrl) in \(collectionId)"
      
    case .moveSlot(let slotIndex, let position, let collectionId):
      return "\(type(of: self)): Moving slot \(slotIndex) to position \(position) in \(collectionId)"
      
    case .invalidateShareLinks(let collectionId):
      return "\(type(of: self)): Invalidating share links for \(collectionId)"
      
    case .setShareLinks(_, _, let collectionId):
      return "\(type(of: self)): Setting share links for \(collectionId)"
      
    case .saveOnRotation:
      return "\(type(of: self)): Saving current On Rotation to Library"
      
    case .createCollection:
      return "\(type(of: self)): Creating a user collection in the Library"
      
    case .addCollection:
      return "\(type(of: self)): Adding a shared collection to the library"
      
    case .copyCollection(let collectionId):
      return "\(type(of: self)): Making a copy of collection \(collectionId)"
      
    case .removeCollection(let libraryIndex):
      return "\(type(of: self)): Removing collection in position \(libraryIndex) from the Library"
      
    case .removeCollections(let collectionIds):
      return "\(type(of: self)): Removing collections with IDs \(collectionIds) from the library"
      
    case .moveCollection(let libraryIndex, let position):
      return "\(type(of: self)): Moving collection \(libraryIndex) to position \(position) in the Library"
      
    case .cueSharedCollection:
      return "\(type(of: self)): Cueing a shared collection"
      
    case .uncueSharedCollection:
      return "\(type(of: self)): Uncueing a shared collection"
      
    }
  }
}
