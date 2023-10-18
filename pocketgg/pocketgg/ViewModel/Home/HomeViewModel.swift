import SwiftUI
import StartggAPI

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
      await fetchTournaments()
    }
  }
  
  func onViewAppear() {
    if shouldRefreshAccessToken() {
      print("REFRESHING ACCESS TOKEN")
      // TODO: Might be causing SWIFT TASK CONTINUATION MISUSE when called
      Task {
        await refreshAccessToken()
        didAttemptTokenRefresh = true
      }
    } else {
      print("NOT REFRESHING ACCESS TOKEN")
    }
  }
  
  func fetchTournaments() async {
    do {
      let tournaments = try await Network.shared.getFeaturedTournaments(pageNum: 1, gameIDs: [1])
      tournamentGroups = [TournamentsGroup(name: "Featured", tournaments: tournaments)]
    } catch {
      print(error) // TODO: handle error
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
