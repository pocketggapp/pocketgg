import StartggAPI

extension StartggService {
  func getVideoGames(name: String, page: Int, accumulatedVideoGameIDs: Set<Int>) async throws -> [VideoGame]? {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: VideoGamesQuery(name: .some(name), pageNum: .some(page))
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let nodes = graphQLResult.data?.videogames?.nodes else {
            continuation.resume(returning: nil)
            return
          }
          
          let videoGames: [VideoGame] = nodes.compactMap {
            guard let id = Int($0?.id ?? "nil"), let name = $0?.name, !accumulatedVideoGameIDs.contains(id) else { return nil }
            return VideoGame(id: id, name: name)
          }
          
          continuation.resume(returning: videoGames)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
