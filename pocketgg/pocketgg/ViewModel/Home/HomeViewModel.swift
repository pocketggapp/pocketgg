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
  
  private let oAuthService: OAuthServiceType
  private let service: StartggServiceType
  private let userDefaults: UserDefaults
  private(set) var didAttemptTokenRefresh = false
  
  init(
    oAuthService: OAuthServiceType = OAuthService.shared,
    service: StartggServiceType = StartggService.shared,
    userDefaults: UserDefaults = .standard
  ) {
    self.state = .uninitialized
    self.oAuthService = oAuthService
    self.service = service
    self.userDefaults = userDefaults
  }
  
  // MARK: Fetch Tournaments
  
  @MainActor
  func fetchTournaments(refreshed: Bool = false) async {
    if !refreshed {
      switch state {
      case .uninitialized: break
      default: return
      }
    }
    
    if shouldRefreshAccessToken() {
      print("REFRESHING ACCESS TOKEN")
      // TODO: Might be causing SWIFT TASK CONTINUATION MISUSE when called
      await refreshAccessToken()
      didAttemptTokenRefresh = true
    } else {
      print("NOT REFRESHING ACCESS TOKEN")
    }
    
    state = .loading
    do {
      let tournaments = try await service.getFeaturedTournaments(pageNum: 1, gameIDs: [1])
      state = .loaded([TournamentsGroup(name: "Featured", tournaments: tournaments)])
    } catch {
      state = .error(error.localizedDescription)
    }
  }
  
  // MARK: Refresh Access Token
  
  @MainActor
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
    let lastRefreshedKey = Constants.accessTokenLastRefreshed
    guard let lastRefreshed = userDefaults.object(forKey: lastRefreshedKey) as? Date else { return true }
    return !Calendar.current.isDate(lastRefreshed, inSameDayAs: Date())
  }
}
