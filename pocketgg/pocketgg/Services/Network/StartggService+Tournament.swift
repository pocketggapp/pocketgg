import Foundation
import StartggAPI

extension StartggService {
  func getTournament(id: Int) async throws -> Tournament? {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: TournamentQuery(id: .some(String(id)))
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let tournament = graphQLResult.data?.tournament,
                let id = Int(tournament.id ?? "nil") else {
            continuation.resume(returning: nil)
            return
          }
          
          let start = DateFormatter.shared.dateFromTimestamp(tournament.startAt)
          let end = DateFormatter.shared.dateFromTimestamp(tournament.endAt)
          let date = start == end ? start : "\(start) - \(end)"
          
          let logoURL = tournament.images?.first(where: { $0?.type == "profile" })??.url
          let bannerImageURL = tournament.images?.first { $0?.type == "banner" }??.url
          let bannerImageRatio = tournament.images?.first { $0?.type == "banner" }??.ratio
          
          var location = ""
          var components = [String]()
          if let city = tournament.city {
            components.append(city)
          }
          if let addrState = tournament.addrState {
            components.append(addrState)
          }
          if let countryCode = tournament.countryCode {
            components.append(countryCode)
          }
          for component in components {
            if !location.isEmpty {
              location += ", "
            }
            location += component
          }
          if location.isEmpty, let isOnline = tournament.isOnline, isOnline {
            location = "Online"
          }
          
          continuation.resume(returning: Tournament(
            id: id,
            name: tournament.name,
            date: date,
            location: location,
            logoImageURL: logoURL,
            bannerImageURL: bannerImageURL,
            bannerImageRatio: bannerImageRatio
          ))
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
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
            events = tournamentEvents.compactMap {
              guard let id = Int($0?.id ?? "nil") else { return nil }
              
              let date = DateFormatter.shared.dateFromTimestamp($0?.startAt)
              var eventType: String?
              if let eventTypeID = $0?.type {
                switch eventTypeID {
                case 1: eventType = "Singles"
                case 2: eventType = "Doubles"
                case 5: eventType = "Teams"
                default: break
                }
              }
              return Event(
                id: id,
                name: $0?.name,
                state: $0?.state?.rawValue,
                winner: EntrantService.getEventWinner($0),
                startDate: date,
                eventType: eventType,
                videogameName: $0?.videogame?.name,
                videogameImage: $0?.videogame?.images?.first??.url
              )
            }
          }
          
          var streams = [Stream]()
          if let tournamentStreams = tournament.streams {
            streams = tournamentStreams.map {
              Stream(
                name: $0?.streamName,
                logoUrl: $0?.streamLogo,
                source: $0?.streamSource?.rawValue,
                streamID: $0?.streamId
              )
            }
          }
          
          var location: Location?
          if let address = tournament.venueAddress {
            location = Location(
              address: address,
              venueName: tournament.venueName,
              latitude: tournament.lat,
              longitude: tournament.lng
            )
          }
          
          let contactInfo = (tournament.primaryContact, tournament.primaryContactType)
          
          var organizer: Entrant?
          if let id = Int(tournament.owner?.id ?? "nil") {
            organizer = Entrant(
              id: id,
              name: tournament.owner?.player?.gamerTag,
              teamName: tournament.owner?.player?.prefix
            )
          }
          
          let registrationCloseDate = DateFormatter.shared.dateFromTimestamp(tournament.registrationClosesAt)
          
          continuation.resume(returning: TournamentDetails(
            events: events,
            streams: streams,
            location: location,
            contact: contactInfo,
            organizer: organizer,
            slug: tournament.slug,
            registrationOpen: tournament.isRegistrationOpen ?? false,
            registrationCloseDate: registrationCloseDate
          ))
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
}
