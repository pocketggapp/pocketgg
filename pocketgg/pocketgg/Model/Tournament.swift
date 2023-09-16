import Foundation

struct TournamentData: Identifiable, Hashable {
  let id = UUID()
  let name: String
  let imageURL: String
  let date: String
}

struct TournamentsGroup: Identifiable {
  let id = UUID()
  let name: String
  let tournaments: [TournamentData]
}
