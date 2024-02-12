import Foundation
import StartggAPI

extension StartggService {
  func getPhaseGroups(id: Int, numPhaseGroups: Int) async throws -> [PhaseGroup]? {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: PhaseGroupsQuery(id: .some(String(id)), perPage: .some(numPhaseGroups))
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let nodes = graphQLResult.data?.phase?.phaseGroups?.nodes else {
            continuation.resume(returning: nil)
            return
          }
          
          let phaseGroups: [PhaseGroup] = nodes.compactMap {
            guard let id = Int($0?.id ?? "nil") else { return nil }
            
            return PhaseGroup(
              id: id,
              name: $0?.displayIdentifier,
              state: ActivityState.allCases[($0?.state ?? 5) - 1].rawValue.capitalized
            )
          }
          
          continuation.resume(returning: phaseGroups)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  func getPhaseGroupDetails(id: Int) async throws -> PhaseGroupDetails? {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: PhaseGroupQuery(id: .some(String(id)))
      ) { [weak self] result in
        switch result {
        case .success(let graphQLResult):
          guard let phaseGroup = graphQLResult.data?.phaseGroup else {
            continuation.resume(returning: nil)
            return
          }
          
          var progressionsOut = Set<Int>()
          if let nodes = phaseGroup.progressionsOut {
            progressionsOut = Set(nodes.compactMap { $0?.originPlacement })
          }
          
          var standings = [Standing]()
          if let nodes = phaseGroup.standings?.nodes {
            standings = nodes.compactMap { EntrantService.getEntrantAndStanding3($0) }
          }
          
          var matches = [PhaseGroupSet]()
          if let nodes = phaseGroup.sets?.nodes {
            matches = nodes.compactMap {
              guard let id = Int($0?.id ?? "nil") else { return nil }
              let entrants = EntrantService.getEntrantsForSet(
                displayScore: $0?.displayScore,
                winnerID: $0?.winnerId,
                slots: $0?.slots
              )
              let outcome = PhaseGroupSetService.getSetOutcome(
                score0: entrants?[safe: 0]?.score,
                score1: entrants?[safe: 1]?.score
              )
              return PhaseGroupSet(
                id: id,
                state: ActivityState.allCases[($0?.state ?? 5) - 1].rawValue.capitalized,
                roundNum: $0?.round ?? 0,
                identifier: $0?.identifier ?? "",
                outcome: outcome,
                fullRoundText: $0?.fullRoundText,
                prevRoundIDs: $0?.slots?.compactMap {
                  guard let prevRoundID = $0?.prereqId else { return nil }
                  return Int(prevRoundID)
                } ?? [],
                entrants: entrants
              )
            }
          }
          
          if let normalizedSets = self?.normalizeSets(matches: matches, bracketType: phaseGroup.bracketType?.value) {
            matches = normalizedSets
          }
          
          let roundLabels = self?.generateRoundLabels(matches: matches, bracketType: phaseGroup.bracketType?.value) ?? []
          
          var phaseGroupSetRounds = [Int: Int]()
          for match in matches {
            if phaseGroupSetRounds[match.id] == nil {
              phaseGroupSetRounds[match.id] = match.roundNum
            }
          }
          
          continuation.resume(returning: PhaseGroupDetails(
            bracketType: phaseGroup.bracketType?.value,
            progressionsOut: progressionsOut,
            standings: standings,
            matches: matches,
            roundLabels: roundLabels,
            phaseGroupSetRounds: phaseGroupSetRounds)
          )
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  /// Sort the sets by identifier, and if a grand finals reset set exists, increment its roundNum
  private func normalizeSets(matches: [PhaseGroupSet], bracketType: BracketType?) -> [PhaseGroupSet]? {
    switch bracketType {
    case .singleElimination, .doubleElimination:
      // First sort the sets by the number of characters in their identifier
      // Then sort the the sets by their identifier's alphabetical order
      var sets = matches.sorted {
        if $0.identifier.count != $1.identifier.count {
          return $0.identifier.count < $1.identifier.count
        } else {
          return $0.identifier < $1.identifier
        }
      }
      
      // In the case of a grand finals reset, the 2nd grand finals may have the same roundNum as the 1st grand finals set
      // Therefore, if a set is detected with identical previous round IDs (meaning that the set is a grand finals reset), increment the roundNum
      for (i, set) in sets.enumerated() {
        guard set.prevRoundIDs.count == 2 else { continue }
        if set.prevRoundIDs[0] == set.prevRoundIDs[1] {
          sets[i].roundNum += 1
        }
      }
      
      return sets
    default: break
    }
    return nil
  }
  
  /// Generate all of the round labels for a bracket (eg. Winners Round 1)
  private func generateRoundLabels(matches: [PhaseGroupSet], bracketType: BracketType?) -> [PhaseGroupDetails.RoundLabel] {
    switch bracketType {
    case .singleElimination, .doubleElimination:
      var roundNums = Set<Int>()
      var roundLabels = [PhaseGroupDetails.RoundLabel]()
      
      for match in matches {
        if !roundNums.contains(match.roundNum) {
          roundLabels.append(.init(id: match.roundNum, text: match.fullRoundText ?? ""))
          roundNums.insert(match.roundNum)
        }
      }
      
      return roundLabels
    default: break
    }
    return []
  }
}
