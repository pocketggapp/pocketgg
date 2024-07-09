import Foundation
import StartggAPI

extension StartggService {
  func getFeaturedTournaments(pageNum: Int, perPage: Int, gameIDs: [Int]) async throws -> [Tournament] {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: FeaturedTournamentsQuery(
          pageNum: .some(pageNum),
          perPage: .some(perPage),
          gameIDs: .some(gameIDs.map { String($0) })
        ),
        queue: .global(qos: .userInitiated)
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let tournamentNodes = graphQLResult.data?.tournaments?.nodes else {
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
          // TODO: Change back to const
          var tournaments = StartggService.convertTournamentNodes(nodes)
          
          // TODO: Mock Data, remove later
          tournaments.append(Tournament(
            id: 548572,
            name: "Big House 11",
            date: "Never",
            location: "Somewhere",
            logoImageURL: nil,
            bannerImageURL: nil,
            bannerImageRatio: nil
          ))
          tournaments.append(Tournament(
            id: 628538,
            name: "Test tournament",
            date: "Never",
            location: "Somewhere",
            logoImageURL: nil,
            bannerImageURL: nil,
            bannerImageRatio: nil
          ))
          tournaments.append(Tournament(
            id: 109112,
            name: "UWaterloo Arcadian 6",
            date: "Never",
            location: "Somewhere",
            logoImageURL: nil,
            bannerImageURL: nil,
            bannerImageRatio: nil
          ))
          
          continuation.resume(returning: tournaments)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  func getUpcomingTournaments(pageNum: Int, perPage: Int, gameIDs: [Int]) async throws -> [Tournament] {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: UpcomingTournamentsQuery(
          pageNum: .some(pageNum),
          perPage: .some(perPage),
          gameIDs: .some(gameIDs.map { String($0) })
        ),
        queue: .global(qos: .userInitiated)
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let tournamentNodes = graphQLResult.data?.tournaments?.nodes else {
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
  
  func getUpcomingTournamentsNearLocation(pageNum: Int, perPage: Int, gameIDs: [Int], coordinates: String, radius: String) async throws -> [Tournament] {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: UpcomingTournamentsNearLocationQuery(
          pageNum: .some(pageNum),
          perPage: .some(perPage),
          gameIDs: .some(gameIDs.map { String($0) }),
          coordinates: .some(coordinates),
          radius: .some(radius)
        ),
        queue: .global(qos: .userInitiated)
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let tournamentNodes = graphQLResult.data?.tournaments?.nodes else {
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
  
  func getOnlineTournaments(pageNum: Int, perPage: Int, gameIDs: [Int]) async throws -> [Tournament] {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: OnlineTournamentsQuery(
          pageNum: .some(pageNum),
          perPage: .some(perPage),
          gameIDs: .some(gameIDs.map { String($0) })
        ),
        queue: .global(qos: .userInitiated)
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let tournamentNodes = graphQLResult.data?.tournaments?.nodes else {
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
  
  // MARK: Convert Tournament Nodes
  
  static func convertTournamentNodes(_ nodes: [TournamentNode]) -> [Tournament] {
    return nodes.compactMap {
      guard let id = Int($0.id ?? "nil") else { return nil }
      
      let start = DateFormatter.shared.dateStringFromTimestamp($0.startAt)
      let end = DateFormatter.shared.dateStringFromTimestamp($0.endAt)
      let date = start == end ? start : "\(start) - \(end)"
      
      let logoURL = $0.images?.first(where: { $0?.type == "profile" })??.url
      let bannerImageURL = $0.images?.first { $0?.type == "banner" }??.url
      let bannerImageRatio = $0.images?.first { $0?.type == "banner" }??.ratio
      
      var location = ""
      var components = [String]()
      if let city = $0.city {
        components.append(city)
      }
      if let addrState = $0.addrState {
        components.append(addrState)
      }
      if let countryCode = $0.countryCode {
        components.append(countryCode)
      }
      for component in components {
        if !location.isEmpty {
          location += ", "
        }
        location += component
      }
      if location.isEmpty, let isOnline = $0.isOnline, isOnline {
        location = "Online"
      }
      
      return Tournament(
        id: id,
        name: $0.name,
        date: date,
        location: location,
        logoImageURL: logoURL,
        bannerImageURL: bannerImageURL,
        bannerImageRatio: bannerImageRatio
      )
    }
  }
}
