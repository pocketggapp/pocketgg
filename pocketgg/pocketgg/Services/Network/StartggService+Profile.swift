import StartggAPI

extension StartggService {
  func getCurrentUserProfile() async throws -> Profile? {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: CurrentUserQuery()
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let user = graphQLResult.data?.currentUser,
                let id = Int(user.id ?? "nil") else {
            continuation.resume(returning: nil)
            return
          }
          
          let profileImageURL = user.images?.first { $0?.type == "profile" }??.url
          let bannerImageURL = user.images?.first { $0?.type == "banner" }??.url
          let bannerImageRatio = user.images?.first { $0?.type == "banner" }??.ratio
          
          let nodes: [TournamentNode] = user.tournaments?.nodes?.map {
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
          } ?? []
          let tournaments = StartggService.convertTournamentNodes(nodes)
          
          let profile = Profile(
            id: id,
            name: user.player?.gamerTag,
            teamName: user.player?.prefix,
            bio: user.bio,
            profileImageURL: profileImageURL,
            bannerImageURL: bannerImageURL,
            bannerImageRatio: bannerImageRatio,
            tournaments: tournaments
          )
          
          continuation.resume(returning: profile)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
