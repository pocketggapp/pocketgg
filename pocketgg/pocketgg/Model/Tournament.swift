import Foundation
import StartggAPI

/// Preview of Tournament data
///
/// Used by **HomeView**
struct Tournament: Hashable {
  let id: Int
  let name: String?
  let date: String?
  let location: String
  let logoImageURL: String?
  let bannerImageURL: String?
  let bannerImageRatio: Double?
}

struct TournamentsGroup: Hashable {
  let id: Int
  let name: String
  let tournaments: [Tournament]
}

/// Complete Tournament data
///
/// Used by **TournamentView**
struct TournamentDetails {
  let events: [Event]
  let streams: [Stream]
  let location: Location?
  let contact: (info: String?, type: String?)
  let organizer: Entrant?
  let slug: String?
  let registrationOpen: Bool
  let registrationCloseDate: String
}

struct TournamentNode {
  let id: ID?
  let name: String?
  let startAt: Timestamp?
  let endAt: Timestamp?
  let isOnline: Bool?
  let city: String?
  let addrState: String?
  let countryCode: String?
  let images: [Image?]?
  
  struct Image {
    let url: String?
    let type: String?
    let ratio: Double?
  }
}
