import SwiftUI
import StartggAPI

enum HomeViewState {
  case uninitialized
  case loading
  case loaded([TournamentsGroup])
  case error(String)
}

final class HomeViewModel: ObservableObject {
  @Published var state: HomeViewState
  
  private let oAuthService: OAuthService
  private var didAttemptTokenRefresh = false
  
  init(oAuthService: OAuthService) {
    self.oAuthService = oAuthService
    self.state = .uninitialized
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
    
    Task {
      switch state {
      case .uninitialized:
        await fetchTournaments()
      default: return
      }
    }
  }
  
  // MARK: Fetch Tournaments
  
  @MainActor
  func fetchTournaments() async {
    state = .loading
    do {
      let tournaments = try await Network.shared.getFeaturedTournaments(pageNum: 1, gameIDs: [1])
      state = .loaded([TournamentsGroup(name: "Featured", tournaments: tournaments)])
    } catch {
      state = .error(error.localizedDescription)
    }
  }
  
  // MARK: Refresh Access Token
  
  private func refreshAccessToken() async {
    do {
      let tokenResponse = try await oAuthService.refreshAccessToken()
      try await oAuthService.saveTokens(tokenResponse)
    } catch {
      state = .error(error.localizedDescription)
    }
  }
  
  private func shouldRefreshAccessToken() -> Bool {
    if didAttemptTokenRefresh { return false }
    let lastRefreshedKey = Constants.UserDefaults.accessTokenLastRefreshed
    guard let lastRefreshed = UserDefaults.standard.object(forKey: lastRefreshedKey) as? Date else { return true }
    return !Calendar.current.isDate(lastRefreshed, inSameDayAs: Date())
  }
}
