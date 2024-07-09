import StartggAPI

extension StartggService {
  func getPhaseGroupSetGames(id: Int) async throws -> [PhaseGroupSetGame] {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: PhaseGroupSetGamesQuery(id: "\(id)"),
        queue: .global(qos: .userInitiated)
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let nodes = graphQLResult.data?.set?.games else {
            continuation.resume(returning: [])
            return
          }
          
          let games: [PhaseGroupSetGame] = nodes.compactMap {
            guard let id = Int($0?.id ?? "nil") else { return nil }
            return PhaseGroupSetGame(
              id: id,
              gameNum: $0?.orderNum,
              winnerID: $0?.winnerId,
              stageName: $0?.stage?.name
            )
          }
          
          continuation.resume(returning: games)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
