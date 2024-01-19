struct Event: Identifiable, Hashable {
  let id: Int?
  let name: String?
  let state: String?
  let winner: Entrant?
  
  // Preloaded data for EventVC
  // Query 1 - TournamentDetailsById
  let startDate: String?
  let eventType: Int?
  let videogameName: String?
  let videogameImage: String?
}
