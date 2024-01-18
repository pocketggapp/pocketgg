import Foundation
import StartggAPI

extension Network {
  
  func getTournamentDetails(id: Int) async throws -> TournamentDetails? {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: TournamentDetailsQuery(id: .some(String(id)))
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let tournament = graphQLResult.data?.tournament else {
            continuation.resume(returning: nil)
            return
          }
          
          var events = [Event]()
          if let tournamentEvents = tournament.events {
            events = tournamentEvents.map {
              let date = DateFormatter.shared.dateFromTimestamp($0?.startAt)
              return Event(
                id: Int($0?.id ?? "nil"),
                name: $0?.name,
                state: $0?.state?.rawValue,
                winner: EntrantService.getEventWinner($0),
                startDate: date,
                eventType: $0?.type,
                videogameName: $0?.videogame?.name,
                videogameImage: $0?.videogame?.images?.compactMap { return ($0?.url, $0?.ratio) }.first
              )
            }
          }
          
          // TODO: streams
          
          continuation.resume(returning: TournamentDetails(events: events))
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
