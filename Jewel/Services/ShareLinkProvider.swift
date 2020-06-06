//
//  ShareLinkProvider.swift
//  Listen Later
//
//  Created by Greg Hepworth on 06/06/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation

class ShareLinkProvider {
  
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
  
  static func getLongLink(for collection: Collection) -> URL? {
    
    var shareableSlots = [ShareableSlot?]()
    
    for slot in collection.slots {
      if let content = slot.album {
        let slot = ShareableSlot(sourceProvider: SourceProvider.appleMusicAlbum, sourceRef: content.id)
        shareableSlots.append(slot)
      } else {
        shareableSlots.append(nil)
      }
    }

    let shareableCollection = ShareableCollection(
      collectionName: collection.name == "My Collection" ? "\(collection.curator)'s Collection" : collection.name,
      collectionCurator: collection.curator,
      collection: shareableSlots
    )

    do {
      let shareableCollectionJson = try JSONEncoder().encode(shareableCollection)
      return URL(string: "https://listenlater.link/s/?c=\(shareableCollectionJson.base64EncodedString())")!
    } catch {
      print(error)
      return nil
    }
  }
  
  static func setShortLink(for url: URL) {

    let longDynamicLink = "https://listenlater.page.link/?link=\(url.absoluteString)"
    
    let firebaseShortLinkBodyRaw = ["longDynamicLink": longDynamicLink]
    guard let firebaseShortLinkBodyRawJSON = try? JSONEncoder().encode(firebaseShortLinkBodyRaw) else {
      print("Could not encode link to JSON")
      store.update(action: CollectionAction.setShareLinkError(errorState: true))
      return
    }

    guard let firebaseApiKey = Bundle.main.infoDictionary?["FIREBASE_API_KEY"] as? String else {
      print ("No Firebase API key found!")
      store.update(action: CollectionAction.setShareLinkError(errorState: true))
      return
    }

    let firebaseRestUrl = URL(string: "https://firebasedynamiclinks.googleapis.com/v1/shortLinks?key=\(firebaseApiKey)")!
    var request = URLRequest(url: firebaseRestUrl)
    request.httpMethod = "POST"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let task = URLSession.shared.uploadTask(with: request, from: firebaseShortLinkBodyRawJSON) { data, response, error in
      if let error = error {
        print ("Firebase API threw error: \(error)")
        store.update(action: CollectionAction.setShareLinkError(errorState: true))
        return
      }
      guard let response = response as? HTTPURLResponse,
        (200...299).contains(response.statusCode) else {
          print ("Firebase gave a server error")
          store.update(action: CollectionAction.setShareLinkError(errorState: true))
          return
      }
      if let mimeType = response.mimeType,
        mimeType == "application/json",
        let data = data {
        do {
          if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            DispatchQueue.main.async {
              if let shortLink = json["shortLink"] as? String {
                store.update(action: CollectionAction.setShareLinkShort(shareLinkShort: URL(string: shortLink)!))
              } else {
                print("There was another error")
                store.update(action: CollectionAction.setShareLinkError(errorState: true))
              }
            }
          }
        } catch let error as NSError {
          print("Failed to load: \(error.localizedDescription)")
          store.update(action: CollectionAction.setShareLinkError(errorState: true))
        }
      }
    }
    task.resume()
  }
  
}
