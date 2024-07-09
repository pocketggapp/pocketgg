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
          guard let tournamentData = graphQLResult.data?.tournament,
                let id = Int(tournamentData.id ?? "nil") else {
            continuation.resume(returning: nil)
            return
          }
          
          let tournamentNode = TournamentNode(
            id: String(id),
            name: tournamentData.name,
            startAt: tournamentData.startAt,
            endAt: tournamentData.endAt,
            isOnline: tournamentData.isOnline,
            city: tournamentData.city,
            addrState: tournamentData.addrState,
            countryCode: tournamentData.countryCode,
            images: tournamentData.images?.map { image in
              TournamentNode.Image(
                url: image?.url,
                type: image?.type,
                ratio: image?.ratio
              )
            }
          )
          let tournament = StartggService.convertTournamentNodes([tournamentNode]).first
          
          continuation.resume(returning: tournament)
        case .failure(let error):
          continuation.resume(throwing: error)
        }
      }
    }
  }
  
  func getTournamentBySlug(slug: String) async throws -> Tournament? {
    return try await withCheckedThrowingContinuation { continuation in
      apollo.fetch(
        query: TournamentBySlugQuery(slug: .some(slug))
      ) { result in
        switch result {
        case .success(let graphQLResult):
          guard let tournamentData = graphQLResult.data?.tournament,
                let id = Int(tournamentData.id ?? "nil") else {
            continuation.resume(returning: nil)
            return
          }
          
          let tournamentNode = TournamentNode(
            id: String(id),
            name: tournamentData.name,
            startAt: tournamentData.startAt,
            endAt: tournamentData.endAt,
            isOnline: tournamentData.isOnline,
            city: tournamentData.city,
            addrState: tournamentData.addrState,
            countryCode: tournamentData.countryCode,
            images: tournamentData.images?.map { image in
              TournamentNode.Image(
                url: image?.url,
                type: image?.type,
                ratio: image?.ratio
              )
            }
          )
          let tournament = StartggService.convertTournamentNodes([tournamentNode]).first
          
          continuation.resume(returning: tournament)
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
              
              let date = DateFormatter.shared.dateStringFromTimestamp($0?.startAt)
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
          
          let startDate = DateFormatter.dateFromTimestamp(tournament.startAt)
          let endDate = DateFormatter.dateFromTimestamp(tournament.endAt)
          
          let registrationCloseDate = DateFormatter.shared.dateStringFromTimestamp(tournament.registrationClosesAt)
          
          continuation.resume(returning: TournamentDetails(
            events: events,
            streams: streams,
            location: location,
            contact: contactInfo,
            organizer: organizer,
            startDate: startDate,
            endDate: endDate,
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
