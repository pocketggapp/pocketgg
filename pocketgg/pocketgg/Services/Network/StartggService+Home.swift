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
          
          let tournaments = tournamentNodes.map {
            let start = DateFormatter.shared.dateFromTimestamp($0?.startAt)
            let end = DateFormatter.shared.dateFromTimestamp($0?.endAt)
            let date = start == end ? start : "\(start) - \(end)"
            
            let logoURL = $0?.images?.first(where: { $0?.type ?? "" == "profile" })??.url
            
            return TournamentData(
              id: Int($0?.id ?? "nil") ?? -1,
              name: $0?.name ?? "",
              imageURL: logoURL ?? "",
              date: date
            )
          }
          continuation.resume(returning: tournaments)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  func getTournamentLocation(id: Int) async throws -> String? {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: TournamentLocationQuery(id: .some(String(id)))
      ) { [weak self] result in
        switch result {
        case .success(let graphQLResult):
          guard let tournament = graphQLResult.data?.tournament else {
            continuation.resume(returning: nil)
            return
          }
          
          var location: String?
          if let address = tournament.venueAddress {
            location = self?.getCityAndCountry(address)
          }
          if location == nil, let isOnline = tournament.isOnline, isOnline {
            location = "Online"
          }
          continuation.resume(returning: location)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  private func getCityAndCountry(_ address: String?) -> String? {
    guard let address else { return nil }
    do {
      if let addressComponents = try NSDataDetector(types: NSTextCheckingResult.CheckingType.address.rawValue)
        .matches(in: address, range: NSRange(location: 0, length: address.utf16.count)).first?.addressComponents,
         let city = addressComponents[.city],
         let state = addressComponents[.state] {
        return "\(city), \(state)"
      }
    } catch {
      return nil
    }
    return nil
  }
}
