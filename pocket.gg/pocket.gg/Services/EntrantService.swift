//
//  EntrantService.swift
//  pocket.gg
//
//  Created by Gabriel Siu on 2021-06-05.
//  Copyright © 2021 Gabriel Siu. All rights reserved.
//

import Foundation

final class EntrantService {
  
  // MARK: getTournamentDetails
  //       TournamentVC
  
  static func getEventWinner(_ event: TournamentDetailsQuery.Data.Tournament.Event?) -> Entrant? {
    guard let event = event else { return nil }
    
    if let participants = event.standings?.nodes?[safe: 0]??.entrant?.participants, participants.count == 1 {
      let teamName = getTeamName(combined: event.standings?.nodes?[safe: 0]??.entrant?.name,
                                 entrantName: participants[0]?.gamerTag)
      return Entrant(id: nil, name: participants[0]?.gamerTag, teamName: teamName)
    }
    
    return Entrant(id: nil, name: event.standings?.nodes?[safe: 0]??.entrant?.name, teamName: nil)
  }
  
  // MARK: getEvent
  //       EventVC
  
  static func getEntrantAndStanding(_ standing: EventQuery.Data.Event.Standing.Node?) -> Standing? {
    guard let standing = standing else { return nil }
    
    if let participants = standing.entrant?.participants, participants.count == 1 {
      let entrantName = standing.entrant?.participants?[0]?.gamerTag
      let teamName = getTeamName(combined: standing.entrant?.name, entrantName: entrantName)
      let entrant = Entrant(id: nil, name: entrantName, teamName: teamName)
      return Standing(entrant: entrant, placement: standing.placement)
    }
    
    return Standing(entrant: Entrant(id: nil, name: standing.entrant?.name, teamName: nil), placement: standing.placement)
  }
  
  // MARK: getEventStandings
  //       StandingsVC
  
  static func getEntrantAndStanding2(_ standing: EventStandingsQuery.Data.Event.Standing.Node?) -> Standing? {
    guard let standing = standing else { return nil }
    
    if let participants = standing.entrant?.participants, participants.count == 1 {
      let entrantName = standing.entrant?.participants?[0]?.gamerTag
      let teamName = getTeamName(combined: standing.entrant?.name, entrantName: entrantName)
      let entrant = Entrant(id: nil, name: entrantName, teamName: teamName)
      return Standing(entrant: entrant, placement: standing.placement)
    }
    
    return Standing(entrant: Entrant(id: nil, name: standing.entrant?.name, teamName: nil), placement: standing.placement)
  }
  
  // MARK: getPhaseGroup
  //       PhaseGroupVC
  
  static func getEntrantAndStanding3(_ standing: PhaseGroupQuery.Data.PhaseGroup.Standing.Node?) -> Standing? {
    guard let standing = standing else { return nil }
    guard let entrant = standing.entrant else { return nil }
    
    if let participants = entrant.participants, participants.count == 1 {
      let id = Int(entrant.id ?? "nil")
      let name = entrant.participants?[0]?.gamerTag
      let teamName = getTeamName(combined: entrant.name, entrantName: name)
      let entrant = Entrant(id: id, name: name, teamName: teamName)
      return Standing(entrant: entrant, placement: standing.placement)
    }
    
    return Standing(entrant: Entrant(id: Int(standing.entrant?.id ?? "nil"), name: standing.entrant?.name, teamName: nil),
                    placement: standing.placement)
  }
  
  static func getEntrantsForSet(displayScore: String?, winnerID: Int?, slots: [PhaseGroupQuery.Data.PhaseGroup.Set.Node.Slot?]?) -> [(entrant: Entrant?, score: String?)]? {
    guard let slots = slots else { return nil }
    
    let entrantsInfo = slots.compactMap { slot -> (entrant: Entrant, fullName: String)? in
      if let participants = slot?.entrant?.participants, participants.count == 1 {
        let entrantName = slot?.entrant?.participants?[0]?.gamerTag
        let teamName = getTeamName(combined: slot?.entrant?.name, entrantName: entrantName)
        let entrant = Entrant(id: Int(slot?.entrant?.id ?? "nil"), name: entrantName, teamName: teamName)
        return (entrant: entrant, fullName: slot?.entrant?.name ?? "")
      }
      
      return (entrant: Entrant(id: Int(slot?.entrant?.id ?? "nil"), name: slot?.entrant?.name, teamName: nil),
              fullName: slot?.entrant?.name ?? "")
    }
    
    guard let displayScore = displayScore else {
      return entrantsInfo.map { (entrant: $0.entrant, score: nil) }
    }
    
    if displayScore == "DQ" {
      guard let winnerID = winnerID else { return entrantsInfo.map { (entrant: $0.entrant, score: nil) } }
      return entrantsInfo.map {
        guard let entrantID = $0.entrant.id else { return (entrant: $0.entrant, score: nil) }
        return (entrant: $0.entrant, score: entrantID == winnerID ? "✓" : "DQ")
      }
    }
    
    let entrantStrings = displayScore.components(separatedBy: " - ")
    return entrantsInfo.map {
      for entrantString in entrantStrings where entrantString.contains($0.fullName) {
        guard let index = entrantString.lastIndex(of: " ") else {
          return (entrant: $0.entrant, score: nil)
        }
        return (entrant: $0.entrant,
                score: String(entrantString[index...]).trimmingCharacters(in: .whitespacesAndNewlines))
      }
      return (entrant: $0.entrant, score: nil)
    }
  }
  
  // MARK: - Remaining Standings & Sets
  
  // MARK: getPhaseGroupStandings
  //       PhaseGroupVC
  
  static func getEntrantAndStanding4(_ standing: PhaseGroupStandingsPageQuery.Data.PhaseGroup.Standing.Node?) -> Standing? {
    guard let standing = standing else { return nil }
    guard let entrant = standing.entrant else { return nil }
    
    if let participants = entrant.participants, participants.count == 1 {
      let id = Int(entrant.id ?? "nil")
      let name = entrant.participants?[0]?.gamerTag
      let teamName = getTeamName(combined: entrant.name, entrantName: name)
      let entrant = Entrant(id: id, name: name, teamName: teamName)
      return Standing(entrant: entrant, placement: standing.placement)
    }
    
    return Standing(entrant: Entrant(id: Int(standing.entrant?.id ?? "nil"), name: standing.entrant?.name, teamName: nil),
                    placement: standing.placement)
  }
  
  // MARK: getPhaseGroupSets
  //       PhaseGroupVC
  
  static func getEntrantsForSet2(displayScore: String?, winnerID: Int?, slots: [PhaseGroupSetsPageQuery.Data.PhaseGroup.Set.Node.Slot?]?) -> [(entrant: Entrant?, score: String?)]? {
    guard let slots = slots else { return nil }
    
    let entrantsInfo = slots.compactMap { slot -> (entrant: Entrant, fullName: String)? in
      if let participants = slot?.entrant?.participants, participants.count == 1 {
        let entrantName = slot?.entrant?.participants?[0]?.gamerTag
        let teamName = getTeamName(combined: slot?.entrant?.name, entrantName: entrantName)
        let entrant = Entrant(id: Int(slot?.entrant?.id ?? "nil"), name: entrantName, teamName: teamName)
        return (entrant: entrant, fullName: slot?.entrant?.name ?? "")
      }
      
      return (entrant: Entrant(id: Int(slot?.entrant?.id ?? "nil"), name: slot?.entrant?.name, teamName: nil),
              fullName: slot?.entrant?.name ?? "")
    }
    
    guard let displayScore = displayScore else {
      return entrantsInfo.map { (entrant: $0.entrant, score: nil) }
    }
    
    if displayScore == "DQ" {
      guard let winnerID = winnerID else { return entrantsInfo.map { (entrant: $0.entrant, score: nil) } }
      return entrantsInfo.map {
        guard let entrantID = $0.entrant.id else { return (entrant: $0.entrant, score: nil) }
        return (entrant: $0.entrant, score: entrantID == winnerID ? "✓" : "DQ")
      }
    }
    
    let entrantStrings = displayScore.components(separatedBy: " - ")
    return entrantsInfo.map {
      for entrantString in entrantStrings where entrantString.contains($0.fullName) {
        guard let index = entrantString.lastIndex(of: " ") else {
          return (entrant: $0.entrant, score: nil)
        }
        return (entrant: $0.entrant,
                score: String(entrantString[index...]).trimmingCharacters(in: .whitespacesAndNewlines))
      }
      return (entrant: $0.entrant, score: nil)
    }
  }
  
  // MARK: - Private Helpers
  
  private static func getTeamName(combined: String?, entrantName: String?) -> String? {
    guard let combined = combined, let entrantName = entrantName else { return nil }

    // entrantName is the name of the entrant (e.g. Mang0)
    // If the entrant doesn't have a team, then combined will be the same as gamerTag
    // If they do have a team, then combined will be the team name + " | " + gamerTag (e.g. C9 | Mang0)
    // So check if combined includes " | ", and if it does, then extract the team name
    if let range = combined.range(of: " | " + entrantName) {
      return String(combined[..<range.lowerBound])
    }
    return nil
  }
}
