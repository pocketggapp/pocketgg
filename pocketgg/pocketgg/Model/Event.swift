struct Event: Identifiable, Hashable {
  let id: Int
  let name: String?
  let state: String?
  let winner: Entrant?
  
  let startDate: String?
  let eventType: String?
  let videogameName: String?
  let videogameImage: String?
}

struct EventDetails {
  let phases: [Phase]
  let topStandings: [Standing]
}
