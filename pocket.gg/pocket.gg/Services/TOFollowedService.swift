//
//  TOFollowedService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-07-26.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import Foundation

final class TOFollowedService {
  
  private static var followedTOs = [TournamentOrganizer]()
  static var numTOsFollowed: Int { followedTOs.count }
  static var noTOsFollowed: Bool { followedTOs.isEmpty }
  
  static func initFollowedTOs() {
    if let data = UserDefaults.standard.data(forKey: k.UserDefaults.tournamentOrganizersFollowed) {
      do {
        followedTOs = try PropertyListDecoder().decode([TournamentOrganizer].self, from: data)
      } catch {
        print(error.localizedDescription)
        followedTOs = []
      }
    }
  }
  
  static func toggleFollowedTO(_ tournamentOrganizer: TournamentOrganizer) -> Bool {
    if let index = followedTOs.firstIndex(where: {
      guard let tournamentOrganizerID = tournamentOrganizer.id, let id = $0.id else { return false }
      return tournamentOrganizerID == id
    }) {
      followedTOs.remove(at: index)
    } else {
      followedTOs.append(tournamentOrganizer)
    }
    
    saveTOsFollowed()
    return true
  }
  
  static func alreadyFollowingTO(_ tournamentOrganizerID: Int) -> Bool {
    return followedTOs.contains(where: {
      guard let id = $0.id else { return false }
      return tournamentOrganizerID == id
    })
  }
  
  static func rearrangeFollowedTOs(sourceIndex: Int, destinationIndex: Int) {
    let movedTournamentOrganizer = followedTOs.remove(at: sourceIndex)
    followedTOs.insert(movedTournamentOrganizer, at: destinationIndex)
    saveTOsFollowed()
  }
  
  static func followedTO(at index: Int) -> TournamentOrganizer? {
    guard let tournamentOrganizer = followedTOs[safe: index] else { return nil }
    return tournamentOrganizer
  }
  
  static func updateTO(at index: Int, customName: String?, customPrefix: String?) {
    guard index < followedTOs.count else { return }
    if let customName = customName, customName.isEmpty, let customPrefix = customPrefix, customPrefix.isEmpty {
      followedTOs[index].customName = nil
      followedTOs[index].customPrefix = nil
    } else if customName == nil, customPrefix == nil {
      followedTOs[index].customName = nil
      followedTOs[index].customPrefix = nil
    } else {
      followedTOs[index].customName = customName
      followedTOs[index].customPrefix = customPrefix
    }
    saveTOsFollowed()
  }
  
  static func removeTO(at index: Int) {
    followedTOs.remove(at: index)
    saveTOsFollowed()
  }
  
  private static func saveTOsFollowed() {
    do {
      UserDefaults.standard.set(try PropertyListEncoder().encode(followedTOs), forKey: k.UserDefaults.tournamentOrganizersFollowed)
    } catch {
      print(error.localizedDescription)
    }
  }
}
