import Foundation

struct TournamentData: Identifiable, Hashable {
  let id: Int
  let name: String?
  let imageURL: String?
  let date: String?
  let location: String
}

struct TournamentsGroup: Identifiable {
  let id = UUID()
  let name: String
  let tournaments: [TournamentData]
}

struct TournamentDetails {
  let events: [Event]
  let streams: [Stream]
  let location: Location?
  let contact: (info: String?, type: String?)
}
