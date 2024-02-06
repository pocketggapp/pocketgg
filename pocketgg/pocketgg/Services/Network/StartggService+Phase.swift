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
      ) { result in
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
                identifier: $0?.identifier,
                outcome: outcome,
                fullRoundText: $0?.fullRoundText,
                prevRoundIDs: $0?.slots?.compactMap {
                  guard let prevRoundID = $0?.prereqId else { return nil }
                  return Int(prevRoundID)
                },
                entrants: entrants
              )
            }
          }
          
          continuation.resume(returning: PhaseGroupDetails(
            bracketType: phaseGroup.bracketType?.rawValue,
            progressionsOut: progressionsOut,
            standings: standings,
            matches: matches)
          )
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
