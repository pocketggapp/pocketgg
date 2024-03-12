/// Preview of Event data
///
/// Used by **TournamentView**
struct Event: Hashable {
  let id: Int
  let name: String?
  let state: String?
  let winner: Entrant?
  
  let startDate: String?
  let eventType: String?
  let videogameName: String?
  let videogameImage: String?
}

/// Complete Event data
///
/// Used by **EventView**
struct EventDetails: Hashable {
  let phases: [Phase]
  let topStandings: [Standing]
}
