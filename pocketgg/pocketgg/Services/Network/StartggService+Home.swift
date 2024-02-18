import Foundation
import StartggAPI

extension StartggService {
  func getFeaturedTournaments(pageNum: Int, gameIDs: [Int]) async throws -> [Tournament] {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: FeaturedTournamentsQuery(pageNum: .some(pageNum), gameIDs: .some(gameIDs.map { String($0) }))
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let tournamentNodes = graphQLResult.data?.tournaments?.nodes else {
            continuation.resume(returning: [])
            return
          }
          
          // TODO: Change back to const
          var tournaments: [Tournament] = tournamentNodes.compactMap {
            guard let id = Int($0?.id ?? "nil") else { return nil }
            
            let start = DateFormatter.shared.dateFromTimestamp($0?.startAt)
            let end = DateFormatter.shared.dateFromTimestamp($0?.endAt)
            let date = start == end ? start : "\(start) - \(end)"
            
            let logoURL = $0?.images?.first(where: { $0?.type == "profile" })??.url
            let bannerImageURL = $0?.images?.first { $0?.type == "banner" }??.url
            let bannerImageRatio = $0?.images?.first { $0?.type == "banner" }??.ratio
            
            var location = ""
            var components = [String]()
            if let city = $0?.city {
              components.append(city)
            }
            if let addrState = $0?.addrState {
              components.append(addrState)
            }
            if let countryCode = $0?.countryCode {
              components.append(countryCode)
            }
            for component in components {
              if !location.isEmpty {
                location += ", "
              }
              location += component
            }
            if location.isEmpty, let isOnline = $0?.isOnline, isOnline {
              location = "Online"
            }
            
            return Tournament(
              id: id,
              name: $0?.name,
              date: date,
              location: location,
              logoImageURL: logoURL,
              bannerImageURL: bannerImageURL,
              bannerImageRatio: bannerImageRatio
            )
          }
          
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
}
