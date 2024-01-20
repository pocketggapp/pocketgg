import Foundation

struct TournamentData: Identifiable, Hashable {
  let id: Int
  let name: String
  let imageURL: String
  let date: String
}

struct TournamentsGroup: Identifiable {
  let id = UUID()
  let name: String
  let tournaments: [TournamentData]
}

struct TournamentDetails {
  let events: [Event]
  let streams: [Stream]
}
