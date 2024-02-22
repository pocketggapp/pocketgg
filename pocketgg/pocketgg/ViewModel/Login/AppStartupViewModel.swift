import SwiftUI

final class AppStartupViewModel: ObservableObject {
  private let oAuthService: OAuthServiceType
  private let userDefaults: UserDefaults
  
  init(
    oAuthService: OAuthServiceType = OAuthService.shared,
    userDefaults: UserDefaults = .standard
  ) {
    self.oAuthService = oAuthService
    self.userDefaults = userDefaults
  }
  
  func accessTokenPresent() -> Bool {
    do {
      guard try KeychainService.getToken(.accessToken) != "" else { return false }
      return true
    } catch {
      return false
    }
  }
  
  // MARK: Refresh Access Token
  
  func refreshAccessToken() async throws {
    let tokenResponse = try await oAuthService.refreshAccessToken()
    try await oAuthService.saveTokens(tokenResponse)
  }
  
  func shouldRefreshAccessToken() -> Bool {
    let lastRefreshedKey = Constants.accessTokenLastRefreshed
    guard let lastRefreshed = userDefaults.object(forKey: lastRefreshedKey) as? Date else { return true }
    return !Calendar.current.isDate(lastRefreshed, inSameDayAs: Date())
  }
}
