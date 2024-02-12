//
//  LibraryActions.swift
//  Stacks
//
//  Created by Greg Hepworth on 03/07/2020.
//  Copyright © 2020 Breakbeat Ltd. All rights reserved.
//

import Foundation
import MusicKit

enum LibraryAction: AppAction {
  
  case setStackName(name: String, stackId: UUID)
  case addAlbumToSlot(album: Album, slotIndex: Int, stackId: UUID)
  case removeAlbumFromSlot(slotIndex: Int, stackId: UUID)
  case setPlaybackLinks(baseUrl: URL, playbackLinks: OdesliResponse, stackId: UUID)
  case saveOnRotation(stack: Stack)
  case createStack
  case addStack(stack: Stack)
  case duplicateStack(stack: Stack)
  case removeStack(stackId: UUID)
  
  var description: String {
    switch self {
      
    case .setStackName(let name, _):
      return "\(type(of: self)): Setting user stack name to \(name)"
      
    case .addAlbumToSlot(let album, let slotIndex, let stackId):
      return "\(type(of: self)): Adding AppleMusicAlbum \(album.id) to slot \(slotIndex) in stack \(stackId)"
      
    case .removeAlbumFromSlot(let slotIndex, let stackId):
      return "\(type(of: self)): Removing album in slot \(slotIndex) from stack \(stackId)"
      
    case .setPlaybackLinks(let baseUrl, _, let stackId):
      return "\(type(of: self)): Setting platform links for any album with \(baseUrl) in \(stackId)"
      
    case .saveOnRotation:
      return "\(type(of: self)): Saving current On Rotation to Library"
      
    case .createStack:
      return "\(type(of: self)): Creating a user stack in the Library"
      
    case .addStack:
      return "\(type(of: self)): Adding a stack to the library"
      
    case .duplicateStack(let stack):
      return "\(type(of: self)): Making a copy of stack \(stack.id)"
      
    case .removeStack(let stackId):
      return "\(type(of: self)): Removing stack \(stackId) from the Library"
      
    }
  }
  
  func update(state: AppState) -> AppState {
    
    var newState = state
    
    func extractStack(stackId: UUID) -> Stack? {
      if newState.library.onRotation.id == stackId {
        return newState.library.onRotation
      } else if let stackIndex = newState.library.stacks.firstIndex(where: { $0.id == stackId }) {
        return newState.library.stacks[stackIndex]
      }
      return nil
    }
    
    func commitStack(stack: Stack) {
      if stack.id == newState.library.onRotation.id {
        newState.library.onRotation = stack
      } else if let stackIndex = newState.library.stacks.firstIndex(where: { $0.id == stack.id }) {
        newState.library.stacks[stackIndex] = stack
      }
    }
    
    switch self {
      
    case let .setStackName(name, stackId):
      if var stack = extractStack(stackId: stackId) {
        stack.name = name
        commitStack(stack: stack)
      }
      
    case let .addAlbumToSlot(album, slotIndex, stackId):
      if var stack = extractStack(stackId: stackId) {
        stack.slots[slotIndex].album = album
        commitStack(stack: stack)
      }
      
    case let .removeAlbumFromSlot(slotIndex, stackId):
      if var stack = extractStack(stackId: stackId) {
        stack.slots[slotIndex] = Slot()
        commitStack(stack: stack)
      }
      
    case let .saveOnRotation(stack):
      let formatter = DateFormatter()
      formatter.dateFormat = "dd MMM ''yy"
      let dateString = formatter.string(from: Date())
      var newStack = stack
      newStack.id = UUID()
      newStack.name = "\(Navigation.Tab.onRotation.rawValue) (\(dateString))"
      newState.library.stacks.insert(newStack, at: 0)
      
    case .createStack:
      let newStack = Stack(name: "New Stack")
      newState.library.stacks.insert(newStack, at: 0)
      
    case let .addStack(stack):
      newState.library.stacks.insert(stack, at: 0)
      
    case let .duplicateStack(stack):
      var duplicatedStack = stack
      duplicatedStack.id = UUID()
      duplicatedStack.name = "Copy of \(stack.name)"
      newState.library.stacks.insert(duplicatedStack, at: 0)
      
    case let .removeStack(stackId):
      newState.library.stacks.removeAll(where: { $0.id == stackId })
      
    case let .setPlaybackLinks(baseUrl, playbackLinks, stackId):
      if var stack = extractStack(stackId: stackId) {
        let indices = stack.slots.enumerated().compactMap({ $1.album?.url == baseUrl ? $0 : nil })
        for i in indices {
          stack.slots[i].playbackLinks = playbackLinks
        }
        commitStack(stack: stack)
      }
      
    }
    
    return newState
    
  }
}
