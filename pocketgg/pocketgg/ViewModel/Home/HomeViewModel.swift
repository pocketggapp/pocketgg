import SwiftUI

@MainActor
class HomeViewModel: ObservableObject {
  
  @Published var tournamentGroups = [TournamentsGroup]()
  @Published var showingAlert = false
  @Published var alertMessage = ""
  
  private let oAuthService: OAuthService
  private var didAttemptTokenRefresh = false
  
  init(oAuthService: OAuthService) {
    self.oAuthService = oAuthService
    
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
  
  func onViewAppear() {
    if shouldRefreshAccessToken() {
      Task {
        await refreshAccessToken()
        didAttemptTokenRefresh = true
      }
    }
  }
  
  // MARK: Refresh Access Token
  
  private func refreshAccessToken() async {
    do {
      let tokenResponse = try await oAuthService.refreshAccessToken()
      try await oAuthService.saveTokens(tokenResponse)
    } catch {
      alertMessage = error.localizedDescription
      showingAlert = true
    }
  }
  
  private func shouldRefreshAccessToken() -> Bool {
    if didAttemptTokenRefresh { return false }
    let lastRefreshedKey = Constants.UserDefaults.accessTokenLastRefreshed
    guard let lastRefreshed = UserDefaults.standard.object(forKey: lastRefreshedKey) as? Date else { return true }
    return !Calendar.current.isDate(lastRefreshed, inSameDayAs: Date())
  }
}
