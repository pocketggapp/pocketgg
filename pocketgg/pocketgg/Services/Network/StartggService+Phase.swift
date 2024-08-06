import StartggAPI

extension StartggService {
  func getPhaseGroups(id: Int, numPhaseGroups: Int) async throws -> [PhaseGroup]? {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: PhaseGroupsQuery(id: .some(String(id)), perPage: .some(numPhaseGroups)),
        queue: .global(qos: .userInitiated)
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
              state: ActivityState.allCases[($0?.state ?? 5) - 1]
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
        query: PhaseGroupQuery(id: .some(String(id))),
        cachePolicy: .fetchIgnoringCacheCompletely,
        queue: .global(qos: .userInitiated)
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
              
              let setNodeSlots = $0?.slots?.map { slot -> PhaseGroupSetNodeSlot in
                let participants = slot?.entrant?.participants?.map { participant -> PhaseGroupSetNodeSlot.Entrant.Participant in
                  PhaseGroupSetNodeSlot.Entrant.Participant(gamerTag: participant?.gamerTag)
                }
                return PhaseGroupSetNodeSlot(
                  entrant: PhaseGroupSetNodeSlot.Entrant(
                    id: Int(slot?.entrant?.id ?? "nil"),
                    name: slot?.entrant?.name,
                    participants: participants ?? [],
                    initialSeedNum: nil
                  )
                )
              }
              let entrants = EntrantService.getEntrantsForSet(
                displayScore: $0?.displayScore,
                winnerID: $0?.winnerId,
                slots: setNodeSlots
              )
              let outcome = PhaseGroupSetService.getSetOutcome(
                score0: entrants?[safe: 0]?.score,
                score1: entrants?[safe: 1]?.score
              )
              return PhaseGroupSet(
                id: id,
                state: ActivityState.allCases[($0?.state ?? 5) - 1],
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
          
          continuation.resume(returning: PhaseGroupDetails(
            bracketType: phaseGroup.bracketType?.value,
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
  
  func getPhaseGroupStandings(id: Int, page: Int) async throws -> [Standing]? {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: PhaseGroupStandingsPageQuery(id: .some(String(id)), page: .some(page)),
        cachePolicy: .fetchIgnoringCacheCompletely,
        queue: .global(qos: .userInitiated)
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let nodes = graphQLResult.data?.phaseGroup?.standings?.nodes else {
            continuation.resume(returning: nil)
            return
          }
          
          let standings = nodes.compactMap { EntrantService.getEntrantAndStanding4($0) }
          
          continuation.resume(returning: standings)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  func getRemainingPhaseGroupSets(id: Int, pageNum: Int) async throws -> [PhaseGroupSet] {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: PhaseGroupSetsPageQuery(id: .some(String(id)), page: .some(pageNum)),
        cachePolicy: .fetchIgnoringCacheCompletely,
        queue: .global(qos: .userInitiated)
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let nodes = graphQLResult.data?.phaseGroup?.sets?.nodes else {
            continuation.resume(returning: [])
            return
          }
          
          let sets: [PhaseGroupSet] = nodes.compactMap {
            guard let id = Int($0?.id ?? "nil") else { return nil }
            
            let setNodeSlots = $0?.slots?.map { slot -> PhaseGroupSetNodeSlot in
              let participants = slot?.entrant?.participants?.map { participant -> PhaseGroupSetNodeSlot.Entrant.Participant in
                PhaseGroupSetNodeSlot.Entrant.Participant(gamerTag: participant?.gamerTag)
              }
              return PhaseGroupSetNodeSlot(
                entrant: PhaseGroupSetNodeSlot.Entrant(
                  id: Int(slot?.entrant?.id ?? "nil"),
                  name: slot?.entrant?.name,
                  participants: participants ?? [],
                  initialSeedNum: nil
                )
              )
            }
            let entrants = EntrantService.getEntrantsForSet(
              displayScore: $0?.displayScore,
              winnerID: $0?.winnerId,
              slots: setNodeSlots
            )
            let outcome = PhaseGroupSetService.getSetOutcome(
              score0: entrants?[safe: 0]?.score,
              score1: entrants?[safe: 1]?.score
            )
            return PhaseGroupSet(
              id: id,
              state: ActivityState.allCases[($0?.state ?? 5) - 1],
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
          
          continuation.resume(returning: sets)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
