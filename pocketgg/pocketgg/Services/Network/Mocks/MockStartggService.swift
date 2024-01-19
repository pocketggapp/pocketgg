final class MockStartggService: StartggServiceType {
  func getFeaturedTournaments(pageNum: Int, gameIDs: [Int]) async throws -> [TournamentData] {
    let image = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTySOlAWdNB8bEx9-r6y9ZK8rco9ptzwHUzm2XcNI0gcQ&s"
    let date = "Jul 21 - Jul 23, 2023"
    return [
      TournamentData(id: 0, name: "Tournament 0", imageURL: image, date: date),
      TournamentData(id: 1, name: "Tournament 1", imageURL: image, date: date),
      TournamentData(id: 2, name: "Tournament 2", imageURL: image, date: date),
    ]
  }
  
  func getTournamentDetails(id: Int) async throws -> TournamentDetails? {
    TournamentDetails(
      events: [
        Event(
          id: 1,
          name: "Smash Bros. Melee Singles",
          state: "COMPLETED",
          winner: Entrant(id: 1, name: "Mang0", teamName: "C9"),
          startDate: "Oct 9, 2016",
          eventType: 1,
          videogameName: "Super Smash Bros. Melee",
          videogameImage: "https://images.start.gg/images/videogame/1/image-36450d5d1b6f2c693be2abfdbc159106.jpg?ehk=kHyxo9ZpitIjPcTdkRi6H4H8JkRXjeM5%2BousqjDV%2B%2FI%3D&ehkOptimized=CRpoBnGE8dtJkSIGcd2811UkurtlEPOKEay%2BqgCETlQ%3D"
        )
      ]
    )
  }
  
  func getTournamentLocation(id: Int) async throws -> String? {
    "Toronto, ON"
  }
}
