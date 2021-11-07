//
//  ShareLinkProvider.swift
//  Listen Later
//
//  Created by Greg Hepworth on 06/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import os.log

class SharedCollectionManager {
  
  enum SourceProvider: String, Codable {
    case appleMusicAlbum
  }
  
  struct ShareableCollection: Codable {
    let schemaName = "jewel-shared-collection"
    let schemaVersion: Decimal = 1.1
    let collectionName: String
    let collectionCurator: String
    let collection: [ShareableSlot?]
    
    enum CodingKeys: String, CodingKey {
      case schemaName = "sn"
      case schemaVersion = "sv"
      case collectionName = "cn"
      case collectionCurator = "cc"
      case collection = "c"
    }
  }
  
  struct ShareableSlot: Codable {
    let sourceProvider: SourceProvider
    let sourceRef: String
    
    enum CodingKeys: String, CodingKey {
      case sourceProvider = "sp"
      case sourceRef = "sr"
    }
  }
  
  static func generateLongLink(for collection: Collection) -> URL? {
    var shareableSlots = [ShareableSlot?]()
    
    for slot in collection.slots {
      if let source = slot.source {
        let slot = ShareableSlot(sourceProvider: SourceProvider.appleMusicAlbum, sourceRef: source.album.id.rawValue)
        shareableSlots.append(slot)
      } else {
        shareableSlots.append(nil)
      }
    }
    
    var collectionShareName = collection.name
    
    if collection.name == Navigation.Tab.onRotation.rawValue {
      let formatter = DateFormatter()
      formatter.dateFormat = "MMM yyyy"
      let dateString = formatter.string(from: Date())
      collectionShareName = "\(collection.curator)'s On Rotation - \(dateString)"
    }  else if collection.name.starts(with: "My ") {
      collectionShareName = collection.name.replaceFirstOccurrence(of: "My ", with: "\(collection.curator)'s ")
    }
    
    let shareableCollection = ShareableCollection(
      collectionName: collectionShareName,
      collectionCurator: collection.curator,
      collection: shareableSlots
    )
    
    do {
      let shareableCollectionJson = try JSONEncoder().encode(shareableCollection)
      return URL(string: "https://listenlater.link/s/?c=\(shareableCollectionJson.base64EncodedString())")!
    } catch {
      os_log("💎 Share Links > Error encoding collection: %s", error.localizedDescription)
      return nil
    }
  }
  
  static func setShareLinks(for collection: Collection) async {
    
    await AppEnvironment.global.update(action: LibraryAction.invalidateShareLinks(collectionId: collection.id))
    
    guard let longLink = generateLongLink(for: collection) else {
      os_log("💎 Share Links > Could not create long link")
      await AppEnvironment.global.update(action: NavigationAction.shareLinkError(true))
      return
    }
    
    let longDynamicLink = "https://listenlater.page.link/?link=\(longLink.absoluteString)"
    
    let firebaseShortLinkBodyRaw = ["longDynamicLink": longDynamicLink]
    guard let firebaseShortLinkBodyRawJSON = try? JSONEncoder().encode(firebaseShortLinkBodyRaw) else {
      os_log("💎 Share Links > Could not encode link to JSON")
      await AppEnvironment.global.update(action: NavigationAction.shareLinkError(true))
      return
    }
    
    let firebaseRestUrl = URL(string: "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=\(Secrets.firebaseAPIKey)")!
    var request = URLRequest(url: firebaseRestUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    do {
      let (data, response) = try await URLSession.shared.upload(for: request, from: firebaseShortLinkBodyRawJSON) as! (Data, HTTPURLResponse)
      
      if !(200...299).contains(response.statusCode) {
        os_log("💎 Share Links > Firebase API Error: %s", data.base64EncodedString().base64Decoded()!)
        await AppEnvironment.global.update(action: NavigationAction.shareLinkError(true))
        return
      }
      
      if response.mimeType == "application/json" {
        do {
          if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let shortLink = json["shortLink"] as? String {
              await AppEnvironment.global.update(action: LibraryAction.setShareLinks(shareLinkLong: longLink, shareLinkShort: URL(string: shortLink)!, collectionId: collection.id))
            } else {
              os_log("💎 Share Links > There was an error")
              await AppEnvironment.global.update(action: NavigationAction.shareLinkError(true))
            }
            return
          }
        } catch let error as NSError {
          os_log("💎 Share Links > Failed to load: %s", error.localizedDescription)
          await AppEnvironment.global.update(action: NavigationAction.shareLinkError(true))
          return
        }
      }
      
    } catch {
      os_log("💎 Share Links > There was an error: %s", error.localizedDescription)
      await AppEnvironment.global.update(action: NavigationAction.shareLinkError(true))
      return
    }
    
  }
  
  static func cueReceivedCollection(receivedCollectionUrl: URL) async {
    if let urlComponents = URLComponents(url: receivedCollectionUrl, resolvingAgainstBaseURL: true) {
      let params = urlComponents.queryItems
      if let receivedCollectionEncoded = Data(base64Encoded: (params!.first(where: { $0.name == "c" })?.value!)!) {
        do {
          let shareableCollection = try JSONDecoder().decode(ShareableCollection.self, from: receivedCollectionEncoded)
          await AppEnvironment.global.update(action: NavigationAction.reset)
          await AppEnvironment.global.update(action: LibraryAction.cueSharedCollection(shareableCollection: shareableCollection))
        } catch {
          os_log("💎 Shared Collection > Could not decode received collection: %s", error.localizedDescription)
        }
      }
    }
  }
  
  static func expandShareableCollection(shareableCollection: ShareableCollection) async {
    let collection = Collection(type: .sharedCollection, name: shareableCollection.collectionName, curator: shareableCollection.collectionCurator)
    
    await AppEnvironment.global.update(action: LibraryAction.addCollection(collection: collection))
    
    for (index, slot) in shareableCollection.collection.enumerated() {
      if slot?.sourceProvider == SourceProvider.appleMusicAlbum {
        await RecordStore.purchase(album: slot!.sourceRef, forSlot: index, inCollection: collection.id)
      }
    }
  }
  
  static func loadRecommendations() async {
    do {
      let (data, _) = try await URLSession.shared.data(from: URL(string: "https://listenlater.link/recommendations.json")!)
      if let decodedResponse = try? JSONDecoder().decode(ShareableCollection.self, from: data) {
        await expandShareableCollection(shareableCollection: decodedResponse)
        return
      }
    } catch {
      os_log("💎 Load Recommendations > Fetch failed: %s", error.localizedDescription)
    }
  }
  
}
