import Foundation

@MainActor
class HomeViewModel: ObservableObject {

  @Published var tournamentGroups = [TournamentsGroup]()

  init() {
    Task {
      self.tournamentGroups = await fetchTournamentGroups()
    }
  }

  private func fetchTournamentGroups() async -> [TournamentsGroup] {
    try? await Task.sleep(nanoseconds: 3_000_000_000)
    return Array(repeating: TournamentsGroup(
      name: "Group",
      tournaments: getTournaments()
    ), count: 2)
  }

  private func getTournaments() -> [TournamentData] {
    let imageURL = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTySOlAWdNB8bEx9-r6y9ZK8rco9ptzwHUzm2XcNI0gcQ&s"
    return [
      TournamentData(
        name: "Genesis 4",
        imageURL: imageURL,
        date: "Jul 21 - Jul 23, 2023"
      ),
      TournamentData(
        name: "Genesis 5",
        imageURL: imageURL,
        date: "Jul 21 - Jul 23, 2023"
      ),
      TournamentData(
        name: "Genesis 6",
        imageURL: imageURL,
        date: "Jul 21 - Jul 23, 2023"
      ),
      TournamentData(
        name: "Genesis 7",
        imageURL: imageURL,
        date: "Jul 21 - Jul 23, 2023"
      )
    ]
  }
}
