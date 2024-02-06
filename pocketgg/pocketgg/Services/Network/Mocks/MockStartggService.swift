final class MockStartggService: StartggServiceType {
  func getFeaturedTournaments(pageNum: Int, gameIDs: [Int]) async throws -> [Tournament] {
    let image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTySOlAWdNB8bEx9-r6y9ZK8rco9ptzwHUzm2XcNI0gcQ&s"
    let date = "Jul 21 - Jul 23, 2023"
    return [
      Tournament(id: 0, name: "Tournament 0", imageURL: image, date: date, location: "Somewhere"),
      Tournament(id: 1, name: "Tournament 1", imageURL: image, date: date, location: "Somewhere"),
      Tournament(id: 2, name: "Tournament 2", imageURL: image, date: date, location: "Somewhere"),
    ]
  }
  
  func getTournamentDetails(id: Int) async throws -> TournamentDetails? {
    TournamentDetails(
      events: [MockStartggService.createEvent()],
      streams: [MockStartggService.createStream()],
      location: MockStartggService.createLocation(),
      contact: MockStartggService.createContactInfo()
    )
  }
  
  func getEventDetails(id: Int) async throws -> EventDetails? {
    EventDetails(
      phases: [MockStartggService.createPhase()],
      topStandings: MockStartggService.createStandings()
    )
  }
  
  func getEventStandings(id: Int, page: Int) async throws -> [Standing]? {
    MockStartggService.createStandings()
  }
  
  func getPhaseGroups(id: Int, numPhaseGroups: Int) async throws -> [PhaseGroup]? {
    [MockStartggService.createPhaseGroup()]
  }
  
  func getPhaseGroupDetails(id: Int) async throws -> PhaseGroupDetails? {
    MockStartggService.createPhaseGroupDetails()
  }
  
  // MARK: Mock Data
  
  static func createEntrant(id: Int) -> Entrant {
    Entrant(id: id, name: "Mang0", teamName: "C9")
  }
  
  static func createEvent() -> Event {
    Event(
      id: 1,
      name: "Smash Bros. Melee Singles",
      state: "COMPLETED",
      winner: createEntrant(id: 1),
      startDate: "Oct 9, 2016",
      eventType: "Singles",
      videogameName: "Super Smash Bros. Melee",
      videogameImage: "https://images.start.gg/images/videogame/1/image-36450d5d1b6f2c693be2abfdbc159106.jpg?ehk=kHyxo9ZpitIjPcTdkRi6H4H8JkRXjeM5%2BousqjDV%2B%2FI%3D&ehkOptimized=CRpoBnGE8dtJkSIGcd2811UkurtlEPOKEay%2BqgCETlQ%3D"
    )
  }
  
  static func createStream() -> Stream {
    Stream(
      name: "VGBootCamp",
      logoUrl: "https://static-cdn.jtvnw.net/jtv_user_pictures/vgbootcamp-profile_image-2d7c9dd9b19b8c44-300x300.png",
      source: "TWITCH",
      streamID: "61213141"
    )
  }
  
  static func createLocation() -> Location {
    Location(
      address: "600 Town Center Dr, Dearborn, MI 48126, USA",
      venueName: "Edward Hotel & Conference Center",
      latitude: 42.3122619,
      longitude: -83.2178603
    )
  }
  
  static func createContactInfo() -> (info: String?, type: String?) {
    (info: "pocketggapp@gmail.com", type: "email")
  }
  
  static func createPhase() -> Phase {
    Phase(
      id: 1,
      name: "Top 8",
      state: "COMPLETED",
      numPhaseGroups: 1,
      numEntrants: 8,
      bracketType: "SINGLE_ELIMINATION"
    )
  }
  
  static func createPhaseGroup() -> PhaseGroup {
    PhaseGroup(id: 1, name: "Top 8", state: "COMPLETED")
  }
  
  static func createPhaseGroupDetails() -> PhaseGroupDetails {
    PhaseGroupDetails(
      bracketType: "DOUBLE_ELIMINATION",
      progressionsOut: [],
      standings: createStandings(),
      matches: [createPhaseGroupSet()]
    )
  }
  
  static func createPhaseGroupSet() -> PhaseGroupSet {
    PhaseGroupSet(
      id: 0,
      state: "Completed",
      roundNum: 3,
      identifier: "A",
      outcome: .entrant0Won,
      fullRoundText: "Grand Final",
      prevRoundIDs: [1, 2],
      entrants: [
        PhaseGroupSetEntrant(entrant: createEntrant(id: 0), score: "3"),
        PhaseGroupSetEntrant(entrant: createEntrant(id: 1), score: "2")
      ]
    )
  }
  
  static func createStanding(id: Int) -> Standing {
    Standing(entrant: createEntrant(id: id), placement: id)
  }
  
  static func createStandings() -> [Standing] {
    [
      createStanding(id: 1),
      createStanding(id: 2),
      createStanding(id: 3),
      createStanding(id: 4),
      createStanding(id: 5),
      createStanding(id: 6),
      createStanding(id: 7),
      createStanding(id: 8)
    ]
  }
}
