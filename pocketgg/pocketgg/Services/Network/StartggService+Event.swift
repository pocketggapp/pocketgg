import StartggAPI

extension StartggService {
  func getEventDetails(id: Int) async throws -> EventDetails? {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: EventDetailsQuery(id: .some(String(id))),
        queue: .global(qos: .userInitiated)
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let event = graphQLResult.data?.event else {
            continuation.resume(returning: nil)
            return
          }
          
          var phases = [Phase]()
          if let eventPhases = event.phases {
            phases = eventPhases.compactMap {
              guard let id = Int($0?.id ?? "nil") else { return nil }
              
              return Phase(
                id: id,
                name: $0?.name,
                state: $0?.state?.rawValue,
                numPhaseGroups: $0?.groupCount,
                numEntrants: $0?.numSeeds,
                bracketType: $0?.bracketType?.value
              )
            }
          }
          
          var topStandings = [Standing]()
          if let nodes = event.standings?.nodes {
            topStandings = nodes.compactMap { EntrantService.getEntrantAndStanding($0) }
          }
          
          continuation.resume(returning: EventDetails(
            phases: phases,
            topStandings: topStandings)
          )
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  func getEventStandings(id: Int, page: Int) async throws -> [Standing]? {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: EventStandingsQuery(id: .some(String(id)), page: .some(page)),
        queue: .global(qos: .userInitiated)
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let nodes = graphQLResult.data?.event?.standings?.nodes else {
            continuation.resume(returning: nil)
            return
          }
          
          let standings = nodes.compactMap { EntrantService.getEntrantAndStanding2($0) }
          
          continuation.resume(returning: standings)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
