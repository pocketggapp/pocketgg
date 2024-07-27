final class MockStartggService: StartggServiceType {
  func getFeaturedTournaments(pageNum: Int, perPage: Int, gameIDs: [Int]) async throws -> [Tournament] {
    [MockStartggService.createTournament(id: 0)]
  }
  
  func getUpcomingTournaments(pageNum: Int, perPage: Int, gameIDs: [Int]) async throws -> [Tournament] {
    [MockStartggService.createTournament(id: 0)]
  }
  
  func getUpcomingTournamentsNearLocation(pageNum: Int, perPage: Int, gameIDs: [Int], coordinates: String, radius: String) async throws -> [Tournament] {
    [MockStartggService.createTournament(id: 0)]
  }
  
  func getOnlineTournaments(pageNum: Int, perPage: Int, gameIDs: [Int]) async throws -> [Tournament] {
    [MockStartggService.createTournament(id: 0)]
  }
  
  func getTournament(id: Int) async throws -> Tournament? {
    MockStartggService.createTournament(id: 0)
  }
  
  func getTournamentBySlug(slug: String) async throws -> Tournament? {
    MockStartggService.createTournament(id: 0)
  }
  
  func getTournamentDetails(id: Int) async throws -> TournamentDetails? {
    MockStartggService.createTournamentDetails()
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
  
  func getPhaseGroupStandings(id: Int, page: Int) async throws -> [Standing]? {
    MockStartggService.createStandings()
  }
  
  func getRemainingPhaseGroupSets(id: Int, pageNum: Int) async throws -> [PhaseGroupSet] {
    [MockStartggService.createPhaseGroupSet()]
  }
  
  func getPhaseGroupSetDetails(id: Int) async throws -> PhaseGroupSetDetails? {
    MockStartggService.createPhaseGroupSetDetails()
  }
  
  func getUserOrganizingTournaments(userID: Int, pageNum: Int, perPage: Int) async throws -> [Tournament] {
    [MockStartggService.createTournament(id: 0)]
  }
  
  func getUserAdminTournaments(userID: Int, pageNum: Int, perPage: Int) async throws -> [Tournament] {
    [MockStartggService.createTournament(id: 0)]
  }
  
  func getUserCompetingTournaments(userID: Int, pageNum: Int, perPage: Int) async throws -> [Tournament] {
    [MockStartggService.createTournament(id: 0)]
  }
  
  func getTournamentsBySearchTerm(name: String, pageNum: Int, perPage: Int) async throws -> [Tournament] {
    [MockStartggService.createTournament(id: 0)]
  }
  
  func getCurrentUserProfile() async throws -> Profile? {
    MockStartggService.createProfile()
  }
  
  func getCurrentUserTournaments(pageNum: Int, perPage: Int) async throws -> [Tournament] {
    [MockStartggService.createTournament(id: 0)]
  }
  
  func getVideoGames(name: String, page: Int, accumulatedVideoGameIDs: Set<Int>) async throws -> [VideoGame]? {
    [MockStartggService.createVideoGame()]
  }
  
  // MARK: Mock Data
  
  static func createTournamentsGroup() -> TournamentsGroup {
    TournamentsGroup(
      id: -2,
      name: "Featured",
      tournaments: [createTournament(id: 0)]
    )
  }
  
  static func createTournament(id: Int) -> Tournament {
    Tournament(
      id: id,
      name: "Tournament \(id)",
      date: "Jul 21 - Jul 23, 2023",
      location: "Somewhere",
      logoImageURL: "https://images.start.gg/images/tournament/517161/image-23d5e280287897018400cb92f524f686.png?ehk=jUpg17LnBumX5JR%2By90B%2F%2BmoxVMeuB2PsdLV10nzguM%3D&ehkOptimized=9SqBHvCIRjjHB3GPMiPodAUVfFG6ySpMFWKmVT5bJNo%3D",
      bannerImageURL: "https://images.start.gg/images/tournament/517161/image-0e0b12a3ec7e661d87fcace5bde6af8e.png?ehk=OAilT7NsdhAxr0l3V%2FQVlq98RQ30rQo%2FVtoX359s6xg%3D&ehkOptimized=wtK4P7FHj0USwucEiggox6TuToYVTLF4iXIq%2BSIUlYQ%3D",
      bannerImageRatio: 4
    )
  }
  
  static func createTournamentDetails() -> TournamentDetails {
    TournamentDetails(
      events: [MockStartggService.createEvent()],
      streams: [MockStartggService.createStream()],
      location: MockStartggService.createLocation(),
      contact: MockStartggService.createContactInfo(),
      organizer: MockStartggService.createEntrant(id: 0),
      startDate: nil,
      endDate: nil,
      slug: "tournament/the-big-house-6",
      registrationOpen: false,
      registrationCloseDate: "January 1, 1970"
    )
  }
  
  static func createEntrant(id: Int) -> Entrant {
    Entrant(id: id, name: "Mang0", teamName: "C9")
  }
  
  static func createEvent() -> Event {
    Event(
      id: 1,
      name: "Smash Bros. Melee Singles",
      state: .completed,
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
      state: .completed,
      numPhaseGroups: 1,
      numEntrants: 8,
      bracketType: .singleElimination
    )
  }
  
  static func createPhaseGroup() -> PhaseGroup {
    PhaseGroup(id: 1, name: "Top 8", state: .completed)
  }
  
  static func createPhaseGroupDetails() -> PhaseGroupDetails {
    PhaseGroupDetails(
      bracketType: .doubleElimination,
      progressionsOut: [],
      standings: createStandings(),
      matches: [createPhaseGroupSet()],
      roundLabels: [createRoundLabel()],
      phaseGroupSetRounds: [:]
    )
  }
  
  static func createRoundLabel() -> PhaseGroupDetails.RoundLabel {
    PhaseGroupDetails.RoundLabel(
      id: 1,
      text: "Grand Final"
    )
  }
  
  static func createPhaseGroupSet() -> PhaseGroupSet {
    PhaseGroupSet(
      id: 0,
      state: .completed,
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
  
  static func createPhaseGroupSetDetails() -> PhaseGroupSetDetails {
    PhaseGroupSetDetails(
      phaseGroupSet: createPhaseGroupSet(),
      games: [createPhaseGroupGame(id: 0)],
      stationNum: 1,
      stream: createStream()
    )
  }
  
  static func createPhaseGroupGame(id: Int) -> PhaseGroupSetGame {
    PhaseGroupSetGame(
      id: id,
      gameNum: 1,
      winnerID: 0,
      stageName: "Yoshi's Story"
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
  
  static func createProfile() -> Profile {
    Profile(
      id: 0,
      name: "Mang0",
      teamName: "C9",
      bio: "GOAT",
      profileImageURL: "https://images.start.gg/images/user/145926/image-bcf05a5636061eb6dbd6ef236d2509fd.jpg?ehk=yevfvToJS2sH14kgjAeXtBttqUv2WYF5TZg2wFvqw2s%3D&ehkOptimized=%2FoS7V284nkLOgU3kCzm%2FmByOfVsPmgdTLJurzc%2B833c%3D",
      bannerImageURL: "https://images.start.gg/images/user/145926/image-747d2cfda61a2cf1d08699971e4ca989.png?ehk=2yJDN%2FtdJMFV%2FVA1NgU8D6m6r3T85OHo4pmVCdEP5pY%3D&ehkOptimized=szJt7wSUXoRptXhbtcF55NpHXSgPIVjP5FHJKoqsj1k%3D",
      bannerImageRatio: 4,
      tournaments: [createTournament(id: 0)]
    )
  }
  
  static func createVideoGame() -> VideoGame {
    VideoGame(
      id: 1,
      name: "Super Smash Bros. Melee"
    )
  }
}
