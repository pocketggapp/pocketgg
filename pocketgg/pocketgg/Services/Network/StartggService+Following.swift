import StartggAPI

extension StartggService {
  func getUserAdminTournaments(userID: Int, pageNum: Int, perPage: Int) async throws -> [Tournament] {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: UserAdminTournamentsQuery(
          id: .some(String(userID)),
          pageNum: .some(pageNum),
          perPage: .some(perPage)
        )
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let tournamentNodes = graphQLResult.data?.user?.tournaments?.nodes else {
            continuation.resume(returning: [])
            return
          }
          
          let nodes = tournamentNodes.map {
            TournamentNode(
              id: $0?.id,
              name: $0?.name,
              startAt: $0?.startAt,
              endAt: $0?.endAt,
              isOnline: $0?.isOnline,
              city: $0?.city,
              addrState: $0?.addrState,
              countryCode: $0?.countryCode,
              images: $0?.images?.map { image in
                TournamentNode.Image(
                  url: image?.url,
                  type: image?.type,
                  ratio: image?.ratio
                )
              }
            )
          }
          let tournaments = StartggService.convertTournamentNodes(nodes)
          
          continuation.resume(returning: tournaments)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
