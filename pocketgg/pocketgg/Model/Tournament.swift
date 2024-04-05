import Foundation

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
