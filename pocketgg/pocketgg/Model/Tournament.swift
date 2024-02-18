import Foundation

/// Preview of Tournament data
///
/// Used by **HomeView**
struct Tournament: Identifiable, Hashable {
  let id: Int
  let name: String?
  let date: String?
  let location: String
  let logoImageURL: String?
  let bannerImageURL: String?
  let bannerImageRatio: Double?
}

struct TournamentsGroup: Identifiable {
  let id = UUID()
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
}
