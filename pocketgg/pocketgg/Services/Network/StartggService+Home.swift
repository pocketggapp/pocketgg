import Foundation
import StartggAPI

extension StartggService {
  func getFeaturedTournaments(pageNum: Int, gameIDs: [Int]) async throws -> [TournamentData] {
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
          var tournaments = tournamentNodes.compactMap { tournament -> TournamentData? in
            guard let id = Int(tournament?.id ?? "nil") else { return nil }
            
            let start = DateFormatter.shared.dateFromTimestamp(tournament?.startAt)
            let end = DateFormatter.shared.dateFromTimestamp(tournament?.endAt)
            let date = start == end ? start : "\(start) - \(end)"
            
            let logoURL = tournament?.images?.first(where: { $0?.type ?? "" == "profile" })??.url
            
            var location = ""
            var components = [String]()
            if let city = tournament?.city {
              components.append(city)
            }
            if let addrState = tournament?.addrState {
              components.append(addrState)
            }
            if let countryCode = tournament?.countryCode {
              components.append(countryCode)
            }
            for component in components {
              if !location.isEmpty {
                location += ", "
              }
              location += component
            }
            if location.isEmpty, let isOnline = tournament?.isOnline, isOnline {
              location = "Online"
            }
            
            return TournamentData(
              id: id,
              name: tournament?.name,
              imageURL: logoURL,
              date: date,
              location: location
            )
          }
          
          // TODO: Mock Data, remove later
          tournaments.append(TournamentData(
            id: 548572,
            name: "Big House 11",
            imageURL: nil,
            date: "Never",
            location: "Somewhere"
          ))
          tournaments.append(TournamentData(
            id: 628538,
            name: "Test tournament",
            imageURL: nil,
            date: "Never",
            location: "Somewhere"
          ))
          
          
          continuation.resume(returning: tournaments)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
